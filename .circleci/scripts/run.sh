#!/bin/bash

CURDIR=$(PWD)
changed=()
changed=$(git whatchanged --oneline --name-only --format="" -n1)

function ENVVAR {
  THISDIR=$(PWD)
  echo \#\!\/bin\/bash > $THISDIR/env.sh
  chmod 775 $THISDIR/env.sh
  DIRS=$(find . -type d -maxdepth 1 -mindepth 1 -exec basename {} \; |grep -v .terraform)
  for DIR in $DIRS; do
  echo $DIR
    echo -n "" > $DIR/env.yaml
    for VARNAME in $(cat $CURDIR/.circleci/env-vars); do 
      LOWVAR=$(echo $VARNAME | tr '[:upper:]' '[:lower:]')
      echo echo\ $LOWVAR\\\:\\\ \\\"\$$VARNAME\\\"\ \>\>\ $DIR/env.yaml >> $THISDIR/env.sh
    done
    bash -c "$THISDIR/env.sh"
  done
}

function RUN {
  terragrunt $CMD --input=false --terragrunt-non-interactive
}

for path in ${changed[@]}; do
  case ${path%%/*} in
  production)
    production=true
  ;;
  testing)
    testing=true
  ;;
  staging)
    staging=true
  ;;
  sandbox)
    sandbox=true
  ;;
  development)
    development=true
  ;;
  esac
done

case $1 in
  init)
    echo "Running tarragrunt init"
    CMD="init"
  ;;
  plan)
    echo "Running tarragrunt plan"
    CMD="plan-all"
  ;;
  apply)
    echo "Running tarragrunt apply"
    CMD="apply-all"
  ;;
  destroy)
    echo "Running tarragrunt destroy"
    CMD="destroy-all"
  ;;
esac

[[ $sandbox     ]] && cd sandbox     && if [ ! $CMD == "init" ]; then ENVVAR; RUN; fi
[[ $testing     ]] && cd testing     && if [ ! $CMD == "init" ]; then ENVVAR; RUN; fi 
[[ $development ]] && cd development && if [ ! $CMD == "init" ]; then ENVVAR; RUN; fi 
[[ $staging     ]] && cd staging     && if [ ! $CMD == "init" ]; then ENVVAR; RUN; fi 
[[ $production  ]] && cd production  && if [ ! $CMD == "init" ]; then ENVVAR; RUN; fi 

if [ $? -ge 0 ]; then
  echo "terragrunt $CMD successful"
  exit 0
else
  echo "terragrunt $CMD exited on error" >&2 
  exit 1
fi
