variable "ec2_ami_id" {
  description = "AMI ID"
  type        = string
  default     = "ami-014d82945a82dfba3"
}

variable "ec2_instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}

variable "ec2_default_root_storage_size" {
  description = "Root volume size"
  type        = number
  default     = 10
}

variable "ec2_tag" {
  description = "EC2 Name tag"
  type        = string
  default     = "automate-instance"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}