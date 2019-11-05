# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git::git@github.com/terraform-aws-modules/terraform-aws-s3-bucket.git?ref=v1.0.0"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependency "kms" {
  config_path = "../kms"
}


# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  bucket           = "tf-test-prorated"

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = dependency.kms.outputs.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}
