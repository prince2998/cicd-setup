resource "aws_security_group" "allow_req_ports_master" {
  name        = "allow_req_ports_master"
  description = "Allow needed ports like ssh, http, https etc"

    dynamic "ingress" {
      for_each = var.ports
      iterator = port
      content {
        description = "TLS from VPC"
        from_port   = port.value
        to_port     = port.value
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }   
    }

  ingress {
    description = "TLS from VPC"
    from_port   = 3000
    to_port     = 10000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
      description = "TLS from VPC"
      from_port   = 30000
      to_port     = 32767
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
output "securityGroupDetails" {
  value = aws_security_group.allow_req_ports_master.id
}

