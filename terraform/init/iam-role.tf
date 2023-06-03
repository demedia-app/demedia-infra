data "aws_iam_instance_profile" "existing" {
  name = "ec2-ssm-role"
}

output "name" {
    value = data.aws_iam_instance_profile.existing.arn
}