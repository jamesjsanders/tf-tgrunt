# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
terraform {
  source = "git::git@github.com:jamesjsanders/tf-tgrunt-modules.git//application?ref=0.1.1"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  maintenance_window                = "wed:06:00-wed:07:00" 
  elasticache_group_node_size       = "cache.t2.micro"
  elasticache_number_cache_clusters = 2
  web_instance_count                = 2
  ec2_web_ami                       = "ami-04b9e92b5572fa0d1"
  ec2_web_instance_type             = "t3a.medium"
  vpc_main_name                     = dependency.vpc.outputs.aws_vpc_main_name
  vpc_main_id                       = dependency.vpc.outputs.aws_vpc_main_id
  aws_subnet_public1_id             = dependency.vpc.outputs.aws_subnet_public1_id
  aws_subnet_public2_id             = dependency.vpc.outputs.aws_subnet_public2_id
  aws_subnet_private1_id            = dependency.vpc.outputs.aws_subnet_private1_id
  aws_subnet_private2_id            = dependency.vpc.outputs.aws_subnet_private2_id
  aws_security_group_bastion_id     = dependency.vpc.outputs.aws_security_group_bastion_id
  aws_security_group_private_id     = dependency.vpc.outputs.aws_security_group_private_id
  aws_security_group_elb_id         = dependency.vpc.outputs.aws_security_group_elb_id
}
