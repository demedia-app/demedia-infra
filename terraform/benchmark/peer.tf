resource "aws_security_group" "peer_ec2_sg" {
  name        = "demedia-benchmark-peer-sg"
  description = "Open ports 22, 80 and 443"

  vpc_id = aws_vpc.us-west-vpc.id

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
    description = "Incoming 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Incoming 10880"
    from_port   = 10880
    to_port     = 10880
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
    Name = "demedia-benchmark-peer-sg"
  }

  provider = aws.us-west-1
}

# Create RSA key of size 4096 bits
resource "tls_private_key" "peer_ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create local file
resource "local_file" "peer_ec2_key" {
  content         = tls_private_key.peer_ec2_key.private_key_pem
  filename        = "${path.module}/keys/peer_ec2_key.pem"
  file_permission = "0600"
}

# Create AWS key pair
resource "aws_key_pair" "peer_ec2_key" {
  key_name   = "peer_key"
  public_key = tls_private_key.peer_ec2_key.public_key_openssh

  provider = aws.us-west-1
}


data "template_file" "peer_userdata" {
  template = file("${path.module}/templates/peer-userdata.sh")
  vars = {
    var_in_bash = var.var_in_bash
  }
}

resource "aws_instance" "peer_ec2" {
  ami                         = "ami-0f8e81a3da6e2510a"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.peer_ec2_sg.id]
  key_name                    = aws_key_pair.peer_ec2_key.key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.us-west_public_subnet.id
  user_data_base64            = base64encode(data.template_file.peer_userdata.rendered)

  tags = {
    Name      = "demedia-benchmark-peer-ec2"
    terraform = true
  }

  provider = aws.us-west-1

  depends_on = [
    aws_vpc_peering_connection_options.aws_vpc_peering_con_options_accepter
   ]
}

output "peer_instance_public_ip" {
  description = "Public IP address of the cient EC2 instance"
  value       = aws_instance.peer_ec2.public_ip
}