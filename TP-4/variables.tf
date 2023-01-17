variable "instancetype" {
  type        = string
  description = "set aws instance type"
  default     = "t2.nano"
}

variable "aws_common_tags" {
  type        = map(any)
  description = "set aws common tags"
  default = {
    name = "ec2-koni"
  }

}

