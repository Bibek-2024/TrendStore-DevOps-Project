# 1. Create Security Group based on your screenshot
resource "aws_security_group" "trendstore_sg" {
  name        = "trendstore-sg"
  description = "Security group rules from image_c8e8f5"

  # Standard Ports: 22, 3000, 8080, 9090
  # These are restricted to your specific IP as per screenshot
  dynamic "ingress" {
    for_each = [22, 3000, 8080, 9090]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [var.my_ip]
    }
  }

  # HTTP Port: 80
  # Per your screenshot, this is open to the world (0.0.0.0/0)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # K8s NodePorts: 30000 - 32767
  # Restricted to your IP
  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  # Full Outbound Access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. EC2 Instance
resource "aws_instance" "jenkins_server" {
  ami                    = "ami-0dee22c13ea7a9a67" # Ubuntu 24.04 Mumbai
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.trendstore_sg.id]

  tags = {
    Name = "TrendStore-Jenkins-Server"
  }
}
