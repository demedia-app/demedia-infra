resource "aws_instance" "demedia-ec2" {
  ami                    = "ami-053b0d53c279acc90"
  instance_type          = "t2.micro"
  key_name               = "demedia-host"
  security_groups        = [aws_security_group.demedia-sg.name]
  iam_instance_profile   = data.aws_iam_instance_profile.existing.arn


  tags = {
    Name = "demedia-host-POC"
  }


}