terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Security Group
resource "aws_security_group" "ssh" {
  name = "security-group-for-ssh"

  ingress {
    description = "SSH ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# for http
resource "aws_security_group" "http" {
  name = "security-group-for-http"

  ingress {
    description = "http ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound http"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Key Pair
resource "aws_key_pair" "k8skey" {
  key_name   = "server"
  public_key = file("/home/davidubuntu/Desktop/kubernetes-class/k8skey.pub")
}

# EC2 Instance
resource "aws_instance" "k8sserver" {
  ami                    = var.instance_ami
  instance_type          = var.Instance_type
  vpc_security_group_ids = [aws_security_group.ssh.id, aws_security_group.http.id]
  key_name               = aws_key_pair.k8skey.key_name
  tags = {
    "Name" : "commander"
    "Description" : "Server for ruing K8s command"
  }

  # --- FILE PROVISIONER ---
  #   provisioner "file" {
  #     source      = "/home/davidubuntu/Desktop/codeplay/instal_docker.sh"
  #     destination = "/tmp/install_docker.sh"
  #     when = create

  #     connection {
  #       type        = "ssh"
  #       user        = "ec2-user"
  #       private_key = file(./server1")  
  #       host        = self.public_ip
  #     }
  #   }


    provisioner "remote-exec" {
      script = "/home/davidubuntu/Desktop/kubernetes-class/config.sh"

      connection {
        type        = "ssh"
        user        = "ec2-user"
        private_key = file("./k8skey")
        host        = self.public_ip
      }
    }
}

output "ip_address" {
  value = aws_instance.k8sserver.public_ip
}
