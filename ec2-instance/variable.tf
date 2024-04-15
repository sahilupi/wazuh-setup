variable "aws_region" {
  description = "region short name for resources tag"
  type        = any
}

variable "vpc_id" {
  description = "vpc id"
  type        = any
}

variable "public_subnet" {
  description = "private subnet"
  type        = any
}

variable "ec2-instance" {
  description = "ec2 instance"
  type        = any
}
