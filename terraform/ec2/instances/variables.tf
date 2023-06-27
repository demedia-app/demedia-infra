variable "iam-instance-profile" {
    type = string
    description = "iam-instance-profile to be attached to the instance"
    default = "ec2-ssm-role"
}
