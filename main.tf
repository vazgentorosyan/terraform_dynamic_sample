provider "aws" {
  region = "us-east-1"
}


resource "aws_vpc" "test" {
  cidr_block = "10.0.0.0/16"

}

locals {
  ingress_rules = [{
    port        = 443
    description = "HTTPS"
    },
    {
      port        = 80
      description = "HTTP"
    },
    {
      port        = 22
      description = "SSH"
    },
    {
      port        = 3389
      description = "RDP"
  }]
}

resource "aws_security_group" "test" {
  name = "common ports allowed"
  #	vpc_id = data.aws_vpc.test.id

  dynamic "ingress" {
    for_each = local.ingress_rules

    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
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
    Name = "learning"
  }
}
