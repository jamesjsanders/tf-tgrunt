#!/bin/bash
set -eo pipefail

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
    [[ $sandbox     ]] && cd sandbox && terragrunt init --input=false --terragrunt-non-interactive
    [[ $testing     ]] && cd testing && terragrunt init --input=false --terragrunt-non-interactive
    [[ $development ]] && cd development && terragrunt init --input=false --terragrunt-non-interactive
    [[ $staging     ]] && cd staging && terragrunt init --input=false --terragrunt-non-interactive
    [[ $production  ]] && cd production && terragrunt init --input=false --terragrunt-non-interactive
  ;;
  plan)
    echo "Running tarragrunt plan"
    [[ $sandbox     ]] && cd sandbox && terragrunt plan-all --input=false --terragrunt-non-interactiv&
    [[ $testing     ]] && cd testing && terragrunt plan-all --input=false --terragrunt-non-interactiv&
    [[ $development ]] && cd development && terragrunt plan-all --input=false --terragrunt-non-interactiv&
    [[ $staging     ]] && cd staging && terragrunt plan-all --input=false --terragrunt-non-interactiv&
    [[ $production  ]] && cd production && terragrunt plan-all --input=false --terragrunt-non-interactive
  ;;
  apply)
    echo "Running tarragrunt apply"
    [[ $sandbox     ]] && cd sandbox && terragrunt apply-all --input=false --terragrunt-non-interactiv&
    [[ $testing     ]] && cd testing && terragrunt apply-all --input=false --terragrunt-non-interactiv&
    [[ $development ]] && cd development && terragrunt apply-all --input=false --terragrunt-non-interactiv&
    [[ $staging     ]] && cd staging && terragrunt apply-all --input=false --terragrunt-non-interactiv&
    [[ $production  ]] && cd production && terragrunt apply-all --input=false --terragrunt-non-interactive
  ;;
  destroy)
    echo "Running tarragrunt destroy"
    [[ $sandbox     ]] && cd sandbox && terragrunt destroy-all --input=false --terragrunt-non-interactiv&
    [[ $testing     ]] && cd testing && terragrunt destroy-all --input=false --terragrunt-non-interactiv&
    [[ $development ]] && cd development && terragrunt destroy-all --input=false --terragrunt-non-interactiv&
    [[ $staging     ]] && cd staging && terragrunt destroy-all --input=false --terragrunt-non-interactiv&
    [[ $production  ]] && cd production && terragrunt destroy-all --input=false --terragrunt-non-interactive
  ;;
esac
