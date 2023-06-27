variable "iam-instance-profile" {
    type = object({
        name = string
        role = string
    })
    description = "values for iam-instance-profile"
}

variable "iam-policy-name" {
    type = string
    description = "name of the iam policy"
}

variable "security-group-name" {
    type = string
    description = "name of the new security group"
}

variable "security-group-description" {
    type = string
    description = "description of the security group"
}

variable "sg-tags" {
  description = "A mapping of tags to assign to security group"
  type        = map(string)
  default     = {
    Name = "demedia-sg"
  }
}
