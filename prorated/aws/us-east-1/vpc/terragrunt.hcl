# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
terraform {
  source = "git::git@github.com:jamesjsanders/tf-tgrunt-modules.git//vpc?ref=0.0.13"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  vpc_name        = "prosand"
  vpc_cidr        = "10.0.0.0/16"
  public1_subnet  = "10.0.11.0/24"
  public2_subnet  = "10.0.12.0/24"
  private1_subnet = "10.0.21.0/24"
  private2_subnet = "10.0.22.0/24"
}
