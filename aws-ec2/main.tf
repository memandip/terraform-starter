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
  # number of similar instances you want to create
  # count = 1

  # Amazon Machine Image (ami), current ami is the id for ubuntu 20.04
  # ami id differs for different regions, so if you change the region
  # you might need to change the ami id as well
  # you can get instance ami from aws console
  ami           = "ami-09e67e426f25ce0d7"
  instance_type = "t2.nano"

  # we need to specify if there's no default vpc
  # vpc_security_group_ids = []

  associate_public_ip_address = true
  key_name                    = aws_key_pair.aws_ec2_key_pair.key_name

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
