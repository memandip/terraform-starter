terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

locals {
  region = "us-east-1"
}

provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

# @TODO: create a reausuable vpc module
# importing vpc module from another directory
# a single source file is not allowed
# module "vpc" {
#   source = "../shared/aws/vpc"
# }

# aws ec2 create-default-vpc
# aws_instance expects a default vpc to exist
# You might need to create default vpc if no default vpc exists

resource "aws_instance" "aws-instance-with-terraform" {
  # Amazon Machine Image (ami), current ami is the id for ubuntu 20.04
  # ami id differs for different regions, so if you change the region
  # you need to change the ami id as well
  ami           = "ami-09e67e426f25ce0d7"
  instance_type = "t2.micro"

  # we need to specify it there's no default vpc
  # vpc_security_group_ids = []

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
