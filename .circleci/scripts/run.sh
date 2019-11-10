#!/bin/bash

changed=()
changed=$(git whatchanged --oneline --name-only --format="" -n1)

for path in ${changed[@]}; do
  case ${path%%/*} in
  production)
    production=true
  ;;
  testing)
    testing=true
  ;;
  staging)
    taging=true
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

[[ $sandbox     ]] && cd sandbox     && terragrunt $CMD --input=false --terragrunt-non-interactive
[[ $testing     ]] && cd testing     && terragrunt $CMD --input=false --terragrunt-non-interactive
[[ $development ]] && cd development && terragrunt $CMD --input=false --terragrunt-non-interactive
[[ $staging     ]] && cd staging     && terragrunt $CMD --input=false --terragrunt-non-interactive
[[ $production  ]] && cd production  && terragrunt $CMD --input=false --terragrunt-non-interactive

if [ $? -ge 0 ]; then
  echo "terragrunt $CMD successful"
  exit 0
else
  echo "terragrunt $CMD exited on error" >&2 
  exit 1
fi
