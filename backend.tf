terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.69"
    }

  }
  required_version = "~> 1.9"
}

provider "aws" {
  region                   = "eu-central-1"
  profile                  = "opfa"

  default_tags {
    tags = {
      Environment   = "showcase"
      Project       = "ssm-showcase"
      ProvisionedBy = "terraform"
      Ownership     = "opfa"
    }
  }
}