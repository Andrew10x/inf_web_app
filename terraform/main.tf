locals {
  project_name        = "Infrastructure labs Project"
  security_group_name = "inf-labs-security-group"
  instance_name       = "inf-labs-ec2"
  ubuntu_ami          = "ami-0faab6bdbac9486fb"
  region              = "eu-central-1"
  key_pair_name       = "inf-lab2"
  author              = "Andew10x"
}

provider "aws" {
  region = local.region
}


resource "aws_instance" "inf-labs-ec2" {
  ami             = local.ubuntu_ami
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.inf-lab2_keys.key_name
  security_groups = [aws_security_group.inf-labs-sg.name]
  user_data       = file("./init.sh")
  tags = {
    Name    = local.instance_name,
    Project = local.project_name,
    Author =  local.author
  }

}


resource "aws_security_group" "inf-labs-sg" {
  name = local.security_group_name

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = local.security_group_name,
    Project = local.project_name,
    Author =  local.author
  }
}

resource "aws_key_pair" "inf-lab2_keys" {
  key_name   = local.key_pair_name
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCteRgiptxzqjLunLDyrtdDFShp4wk3g4VftkCYQ2VZMfLG2Ymm4F5z3/bWZy91TkSghBORIRiWXPBzXKasoMJPbfSJITQ/yEP5+cV91wDzwzG+LwFUI+VxHKj4oPfpJVLM7N36rJGuSmM6ZikL327k2FzQN4dsAW4gQoqk7eKNuRQZr+8XFsCJ5ppeq7/nMXJjIVBFEi8YNce+VT2IUajncIymmQWf3osLbPM9s/fFAqscq9AhgjVhwp8UufPTyPnbfuRRzcJ8nhj7JqSBCaguAkFmHedVNygGmt+8w0QzfYa7B8AnfxBw2jUKytQEAwEMm3MOhlZNNYiPrVPnlqDD"

  tags = {
    Name    = local.key_pair_name,
    Project = local.project_name,
    Author =  local.author
  }
}


output "ec2-public-dns" {
  value = aws_instance.inf-labs-ec2.public_dns
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  cloud {
    organization = "Inf_Labs"

    workspaces {
      name = "Inf_Lab2"
    }
  }

  required_version = ">= 1.2.0"
}

