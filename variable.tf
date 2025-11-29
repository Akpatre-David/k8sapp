# Deployment region

variable "aws_region" {
  description = "region to deploy"
  type        = string
  default     = "us-east-1"
}

# image type

variable "instance_ami" {
  description = "AMI ID for th ec2 instance"
  type        = string
  default     = "ami-0fa3fe0fa7920f68e"
}


# instance type

variable "Instance_type" {
  description = "The Instance Type for the EC2"
  type        = string
  default     = "t3.micro"
}

