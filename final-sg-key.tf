resource "aws_security_group" "my_sg" {
  name_prefix = "pj"
  description = "all ports allowed"
  dynamic "ingress" {
    for_each = [80, 443, 8080, 3306, 22]
    iterator = port
    content {
      description = "all the ports are opened"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

output "security_group_id" {
  value = aws_security_group.my_sg.id
}

resource "aws_key_pair" "pawan_key" {
  key_name   = "pj-key"
  public_key = file("${path.module}/id_rsa.pub")
}

output "key_pair_name" {
  value = aws_key_pair.pawan_key.key_name
}

resource "aws_instance" "web" {
  ami                    = "ami-0b9a26d37416470d2"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.pawan_key.key_name
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  tags = {
    Name = "first-tf-instance"
  }
}
