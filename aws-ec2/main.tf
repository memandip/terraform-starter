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

# @TODO: currently, on some changes in configuration
# the terraform destroys previous instance and creates a new one along with different associated public IP
# find a way to keep the old instance and apply all the changes to the old instance
resource "aws_instance" "aws-instance-with-terraform" {
  # number of similar instances you want to create
  # count = 1

  # Amazon Machine Image (ami), current ami is the id for ubuntu 20.04 ("ami-09e67e426f25ce0d7")
  # ami id differs for different regions, so if you change the region
  # you might need to change the ami id as well
  # you can get instance ami from aws console
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.nano"

  availability_zone = "${local.region}f"

  # we need to specify if there's no default vpc
  # vpc_security_group_ids = []

  associate_public_ip_address = true
  # key_name                    = aws_key_pair.aws_ec2_key_pair.key_name

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = "20"
  }

  lifecycle {
    # prevent_destroy = true
    create_before_destroy = true
    ignore_changes        = []
  }

  # adding ssh connection for ubuntu user
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


##############################################################################
# configure Security Groups to make our EC2 instance publicly accessible     #
##############################################################################
variable "ingressrules" {
  type    = list(number)
  default = [80, 443, 22]
}

resource "aws_security_group" "web_traffic" {
  name        = "Allow web traffic"
  description = "Allow ssh and standard http/https ports inbound and everything outbound"

  dynamic "ingress" {
    iterator = port
    for_each = var.ingressrules
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Terraform" = "true"
  }
}
