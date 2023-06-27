# data "aws_eip" "existing" {
#   id = "eipalloc-0d5e7a8bd819a2222"
# }

# resource "aws_eip_association" "demedia-eip" {
#   # instance_id   = aws_instance.demedia-ec2.id
#   allocation_id = data.aws_eip.existing.id
# }
