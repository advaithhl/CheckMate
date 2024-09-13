terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.18.0"
    }
  }

### Using local backend for testing.
#   backend "s3" {
#     bucket         = "checkmate-tfstate-test"
#     key            = "state/terraform.tfstate"
#     region         = "ap-south-1"
#     encrypt        = true
#     dynamodb_table = "checkmate-tf-test"
#   }
}
