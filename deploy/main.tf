provider "aws" {
  version = "~> 2.40"
  region  = "us-east-1"
}


data "aws_ami" "machine-image" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "name"
    values = ["demo-web-vVERSION*"]
  }
}
data "aws_subnet" "network" {
  filter {
    name   = "tag:Name"
    values = ["pub-subnet-a"]
  }
}
data "aws_security_group" "firewall" {
  filter {
    name   = "vpc-id"
    values = ["${data.aws_subnet.network.vpc_id}"]
  }
  filter {
    name   = "group-name"
    values = ["default"]
  }
}

module "virtual-machine" {
  source = "./modules/ec2-instance"

  ami_id    = "${data.aws_ami.machine-image.id}"
  subnet_id = "${data.aws_subnet.network.id}"

  instance_type = "t2.micro"
  volume_size   = "20"
  volume_type   = "gp2"

  security_group_id         = "${module.firewall.security_group_id}"
  default_security_group_id = "${data.aws_security_group.firewall.id}"

  name = "demo-web-vVERSION"
}

module "firewall" {
  source = "./modules/security-group"

  vpc_id              = "${data.aws_subnet.network.vpc_id}"
  security_group_name = "demo-web-vVERSION"

  http_port  = "80"
  https_port = "443"
  ssh_port   = "22"

  trusted_ip = ["0.0.0.0/0"]
  all_ip     = ["0.0.0.0/0"]

  name = "demo-web-vVERSION"
}

