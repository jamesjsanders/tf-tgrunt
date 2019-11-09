# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"

  config = {
    encrypt        = true
    bucket         = "tf-remote-state-prorated"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state"
  }
}

# GLOBAL PARAMETERS - These variables apply to all configurations in this subfolder. These are automatically merged into the child
locals {
  default_yaml_path = "${find_in_parent_folders("empty.yaml")}"
}

# Configure root level variables that all resources can inherit.
inputs = merge(
  yamldecode(
    file("${get_terragrunt_dir()}/${find_in_parent_folders("region.yaml", local.default_yaml_path)}"),
  ),
  {
    aws_profile = "default"
    environment = "sandbox"
  },
)
