variable "environment" {
  description = "The environment to deploy to"
  default     = "dev"
}

variable "region" {
  description = "The AWS region to deploy to"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "The EC2 instance type"
  default     = "t3.micro" 
}

variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  default     = "ami-0d27e0fb3bac4d724"
}