#!/bin/bash

RUNTF=false
CHANGED=$(git whatchanged --oneline --name-only --format="" -n1)
GITTAGS=$(git tag -l --points-at HEAD)

function ENVVAR {
  echo \#\!\/bin\/bash > ../env.sh && chmod 775 ../env.sh
  DIRS=$(find . -type d -maxdepth 1 -mindepth 1 -exec basename {} \; |grep -v .terraform)
  for DIR in $DIRS; do
  echo $DIR
    echo -n "" > $DIR/env.yaml
    for VARNAME in $(cat ../.circleci/env-vars); do
      LOWVAR=$(echo $VARNAME | tr '[:upper:]' '[:lower:]')
      echo echo\ $LOWVAR\\\:\\\ \\\"\$$VARNAME\\\"\ \>\>\ $DIR/env.yaml >> ../env.sh
    done
    bash -c "../env.sh"
  done
}

RUN() {
  RUNTF=true
  echo "Terragrunt Running CMD: $CMD - Environment: $1"
  terragrunt $CMD --input=false --terragrunt-non-interactive
  TFREXC=$?
}

for path in ${CHANGED[@]}; do
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

[[ $sandbox     ]] && cd sandbox     && if [ ! $CMD == "init" ]; then ENVVAR; RUN sandbox; else RUN sandbox; fi
[[ $testing     ]] && cd testing     && if [ ! $CMD == "init" ]; then ENVVAR; RUN testing; else RUN testing; fi
[[ $development ]] && cd development && if [ ! $CMD == "init" ]; then ENVVAR; RUN development; else RUN development; fi
[[ $staging     ]] && cd staging     && if [ ! $CMD == "init" ]; then ENVVAR; RUN staging; else RUN staging; fi
[[ $production  ]] && cd production  && if [ ! $CMD == "init" ]; then ENVVAR; RUN production; else RUN production; fi

if [ $RUNTF = true ]; then
  if [ 1 -ge $TFREXC ]; then
    echo "Terragrunt CMD $CMD RUN Success - Exit Code: $TFREXC"
    exit 0
  else
    echo "Terragrunt CMD $CMD Failed - Exit Code: $TFREXC" >&2
    exit 1
  fi
fi

exit 0
