variable "instance_type" {
  description = "EC2 instance type for the nginx server."
  type        = string
  default     = "t3.micro"
}

data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "web" {
  name_prefix = "henaogiordy-web-"
  description = "Allow HTTP from the internet"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "henaogiordy-web-sg"
  }
}

resource "aws_instance" "nginx" {
  ami                         = data.aws_ssm_parameter.al2023_ami.value
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    dnf install -y nginx
    echo "<h1>Hola desde Terraform + nginx</h1>" > /usr/share/nginx/html/index.html
    systemctl enable --now nginx
  EOF

  user_data_replace_on_change = true

  tags = {
    Name = "henaogiordy-nginx"
  }
}

output "nginx_public_ip" {
  description = "Public IP of the nginx server."
  value       = aws_instance.nginx.public_ip
}

output "nginx_url" {
  description = "URL to reach the nginx server."
  value       = "http://${aws_instance.nginx.public_dns}"
}
