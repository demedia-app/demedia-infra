resource "aws_security_group" "client_ec2_sg" {
  name        = "demedia-benchmark-client-sg"
  description = "Open ports 22, 80 and 443"

  vpc_id = aws_vpc.us-east-vpc.id

  ingress {
    description = "incoming SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Incoming 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Incoming 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow all incoming ICMP IPv4 traffic"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "demedia-benchmark-client-sg"
  }

  provider = aws.us-east-1
}

# Create RSA key of size 4096 bits
resource "tls_private_key" "client_ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create local file
resource "local_file" "client_ec2_key" {
  content         = tls_private_key.client_ec2_key.private_key_pem
  filename        = "${path.module}/keys/client_ec2_key.pem"
  file_permission = "0600"
}

# Create AWS key pair
resource "aws_key_pair" "client_ec2_key" {
  key_name   = "client_key"
  public_key = tls_private_key.client_ec2_key.public_key_openssh
  provider   = aws.us-east-1
}


data "template_file" "client_userdata" {
  template = file("${path.module}/templates/client-userdata.sh")
  vars = {
    peer_priv_ip = "${aws_instance.peer_ec2.private_ip}"
  }
}

resource "aws_instance" "client_ec2" {
  ami                         = "ami-053b0d53c279acc90"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.client_ec2_sg.id]
  key_name                    = aws_key_pair.client_ec2_key.key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.us-east_public_subnet.id
  user_data_base64            = base64encode(data.template_file.client_userdata.rendered)

  tags = {
    Name      = "demedia-benchmark-client-ec2"
    terraform = true
  }

  provider = aws.us-east-1

  depends_on = [
    aws_vpc_peering_connection_options.aws_vpc_peering_con_options_accepter,
    aws_instance.peer_ec2
  ]

}

output "client_instance_public_ip" {
  description = "Public IP address of the cient EC2 instance"
  value       = aws_instance.client_ec2.public_ip
}