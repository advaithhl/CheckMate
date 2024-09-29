# Terraform Block: Required Providers
# This section specifies the required providers for the project and their respective versions.
# In this case, the HashiCorp AWS provider is used for interacting with AWS services,
# and the Random provider is used for generating random values like passwords or tokens.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.67.0" # Uses version 5.67.x of the AWS provider
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.3" # Uses version 3.6.x of the Random provider
    }
  }
}

# AWS Provider: Configuration
# This block defines the AWS provider configuration.
# No region or credentials are specified here, so the default AWS CLI settings will be used.
provider "aws" {}

# Random Provider: Configuration
# This block defines the Random provider configuration, which generates random values.
# No additional configuration is needed here.
provider "random" {}
