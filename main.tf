#
# Variables values for AWS are set in terraform.tfvars
#

provider "aws" {
  region     = "${var.region}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

##################################################################
# Data sources to get VPC, subnet, security group and AMI details
##################################################################
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = "${data.aws_vpc.default.id}"
}

#
# Commented out below because the ID is directly specified in ec2 module.
# Just left this here as an example
#
/*
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name = "name"
    values = [ "coreos-stable-*" ]
  }

  filter {
    name = "owner-alias"
    values = [ "amazon" ]
  }
}
*/

module "security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "example"
  description = "Security group for example usage with EC2 instance"
  vpc_id      = "${data.aws_vpc.default.id}"

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp","http-80-tcp", "all-icmp"]
  egress_rules        = ["all-all"]
}

resource "aws_eip" "this" {
  vpc      = true
  instance = "${module.ec2.id[0]}"
}

module "ec2" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  name                        = "example"
  ami                         = "ami-7e4b1b07"
  instance_type               = "t2.micro"
  subnet_id                   = "${element(data.aws_subnet_ids.all.ids, 0)}"
  vpc_security_group_ids      = ["${module.security_group.this_security_group_id}"]
  associate_public_ip_address = true
  key_name		      = "ec2kpeuwest1"
  user_data		      = "${file("gollum.conf")}"
}
