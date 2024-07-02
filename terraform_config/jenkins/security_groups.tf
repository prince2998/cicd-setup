resource "aws_security_group" "allow_req_ports_jenkins" {
  name        = "allow_req_ports_jenkins"
  description = "Allow needed ports like ssh, http, https etc"

<<<<<<< HEAD
 ingress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
=======
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

>>>>>>> d51ee086c26798c306043411f6ff9bdc717945c6
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "securityGroupDetails" {
  value = aws_security_group.allow_req_ports_jenkins.id
}
