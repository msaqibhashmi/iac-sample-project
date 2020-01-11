provider "aws" {
  version = "~> 2.32.0"
  region     = "${var.region}"
}

data "aws_ami" "ec2-ami" {
  most_recent = true
  owners = ["self"]
  filter {
    name   = "tag:Name"
    values = ["static-demo-*"]
  }
}

resource "aws_instance" "static-web" {
  ami           = "${data.aws_ami.ec2-ami.id}"
  subnet_id     = "subnet-00fa4d077c46d9a76"
  instance_type = "t2.micro"
  availability_zone = "${var.zone}"
  security_groups = ["${aws_security_group.static-web-fw.id}"]

  ebs_block_device {
    device_name = "/dev/xvda"
    volume_size = 20
    volume_type = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name = "${var.tag}"
  }
}

resource "aws_security_group" "static-web-fw" {
  vpc_id      = "vpc-01bb3c2a934b21783"
  name        = "static-demo-sa01web-v2"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = "${var.all_ip}"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = "${var.all_ip}"
  }

  tags = {
    Name = "${var.tag}"
  }
}

