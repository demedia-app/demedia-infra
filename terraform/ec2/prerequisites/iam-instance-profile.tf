
resource "aws_iam_role" "ec2-iam-role" {
  name = var.iam-instance-profile.role

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

data "aws_iam_policy" "required-policy" {
  name = var.iam-policy-name
}

resource "aws_iam_policy_attachment" "policy-attachment" {
  name = "Attaching managed policy to IAM role"
  roles      = [aws_iam_role.ec2-iam-role.name]
  policy_arn = data.aws_iam_policy.required-policy.arn
}

resource "aws_iam_instance_profile" "demedia-ec2-ssm-role" {
  name = var.iam-instance-profile.name
  role = aws_iam_role.ec2-iam-role.name
}
