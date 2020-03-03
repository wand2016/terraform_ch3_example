module "security_group" {
  source = "../security_group"
}

variable "instance_type" {}

resource "aws_instance" "default" {
  ami = data.aws_ami.recent_amazon_linux_2.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [module.security_group.id]

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

output "public_dns" {
  value = aws_instance.default.public_dns
}