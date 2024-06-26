resource "aws_security_group" "my-sg" {
  name        = "pj"
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
}
