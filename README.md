# Example of terragrunt setup with Circleci

## Structure

At the root of this repository contains environment name directories, ex: ***sandbox*** which in this case is dedicated to an AWS account.
In this example the ***sandbox*** directory contains a subfolder named as the region in which has been targeted for terragrunt deployments. 
  
# Repository current layout

Uses this following folder hierarchy:

```
|-- empty.yaml
`-- account
    |-- state.tf
    |-- terragrunt.hcl
    `-- region
        |-- application
        |   `-- terragrunt.hcl
        |-- vpc_deployment
        |   `-- terragrunt.hcl
        |-- region.yaml
        `-- env.yaml
```

Where: 

* **account** is an AWS Account Environment, ex: **sandbox** 
  * **terragrunt.hcl** is configured for **plan-all**, **apply-all** and **destroy-all** terragrunt commands
* **region** is the AWS Region in which to deploy **us-east-1**
* **aplication**/**vpc_deployment** is the resource in which you want to deploy
  * **terragrunt.hcl** confiuged for **application** specific deployments
* **region.yaml** contains all regsion specific environment variables 
* **env.yaml** injects CI/CD enviornment variables, Circleci in this case
