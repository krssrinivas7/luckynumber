provider "aws" {
  region = "us-east-1"
}

# IAM Role for ECR Full Access
resource "aws_iam_role" "ecr_full_access" {
  name = "ECRFullAccessRole"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

# Attach AmazonEC2ContainerRegistryFullAccess policy to the IAM Role
resource "aws_iam_policy_attachment" "ecr_full_access_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
  role       = aws_iam_role.ecr_full_access.name
}

# Security Group
resource "aws_security_group" "SG" {
  name        = "SG"
  description = "Allow All Inbound and Outbound Traffic"

  # Ingress rule for all inbound traffic
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rule for all outbound traffic
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group Rules for HTTP and HTTPS
resource "aws_security_group_rule" "http" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.SG.id
}

resource "aws_security_group_rule" "https" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.SG.id
}

# EC2 Instance with IAM Role and Security Group
resource "aws_instance" "srinivas" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  key_name      = "task"
  count         = 1

  # Attach the IAM role for ECR Full Access
  iam_instance_profile = aws_iam_instance_profile.ecr_full_access.name

  provisioner "file" {
    source      = "software.sh"
    destination = "/tmp/software.sh" 
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/software.sh",
      "sudo ./tmp/software.sh"  # Added 'sudo' to execute as root
    ]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("task.pem")
    host        = self.public_ip
  }

  # Reference the security group created above
  security_groups = [aws_security_group.SG.name]
}