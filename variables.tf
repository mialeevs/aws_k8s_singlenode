variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "The Default AWS region"
}


variable "ec2_instance_name" {
  type        = string
  default     = "K8S_CP_Node"
  description = "The Default AWS EC2 name"
}

variable "ec2_instance_type" {
  type        = string
  default     = "t3.medium"
  description = "The default instance type for single K8S node"
}

variable "ec2_ami_id" {
  type        = string
  default     = "ami-0c7217cdde317cfec"
  description = "The default AMI for Virginia region"
}

variable "my_ip" {
  type        = string
  description = "My public IP"
}
