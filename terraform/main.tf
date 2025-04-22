resource "aws_key_pair" "mykey" {
  key_name   = var.key_name
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDka3S6xn4rrUeh3N2uDru7olldydum9gpZXyW1JWJxzi9tkXKT7qHz1M8cNInxnbVQps+vTuxDyiJbjcFDh8xvkt39DIATAgmC/HdcFYznBs+lxLOmIAzhTJs0qC/ShLDRWeVXSIPXmUmpJ9FDtk+Rrh0dfNQ0EGak9ziOg3eE/noDDqSIWffXfcqHPdyi7vrr4i15awyFefPV3UqQNFfnops0W5fd7KrJG0/Oy1NRI/HrBTv2nlxc5RRIFIdMQ1e5vy/BWIPyvqQKAfRiZFWrBs9bpeoBJ5UaUSr6ucwWhJkJwhr6dixu3Hr0JjeufSVLyQ3j3Z4IyoYlESKHjsNl"
}

resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
ingress {
  from_port   = 22
  to_port     = 22
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

resource "aws_instance" "web_app" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.mykey.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install docker.io -y
              sudo systemctl start docker
              sudo docker run -d -p 80:80 1nterceptor/ci-cd-lab:latest
              EOF

  tags = {
    Name = "CI-CD-Lab-Instance"
  }
}
