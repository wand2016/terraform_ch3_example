provider "aws" {
  region = "ap-northeast-1"
}

variable "instance_type" {}

resource "aws_instance" "default" {
  ami = data.aws_ami.recent_amazon_linux_2.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.default.id]

  user_data = file("./user_data.sh")
}

data "aws_ami" "recent_amazon_linux_2" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }

  filter {
    name = "state"
    values = ["available"]
  }
}

resource "aws_security_group" "default" {
  name = "ec2"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


output "public_dns" {
  value = aws_instance.default.public_dns
}
