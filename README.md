# Example of terragrunt setup

## Setup

* Account
  * aws (cloud provider)
    * terragrunt.hcl = state file
    * region ( aws region )
     * env.yaml ( region high level enviornment file )
     * module/app folder
        * terragrunt.hcl = Module Source and Inputs
