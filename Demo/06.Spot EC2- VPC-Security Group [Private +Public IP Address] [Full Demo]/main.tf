terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "terraformlab"
}

resource "aws_vpc" "rnd_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "first_lab"
  }
}

resource "aws_internet_gateway" "rnd_igw" {
  vpc_id = aws_vpc.rnd_vpc.id

  tags = {
    Name = "rnd-igw"
  }
}

resource "aws_route_table" "rnd_rt" {
  vpc_id = aws_vpc.rnd_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rnd_igw.id
  }

  tags = {
    Name = "rnd-route-table"
  }
}

resource "aws_route_table_association" "rnd_rta" {
  subnet_id      = aws_subnet.rnd_subnet.id
  route_table_id = aws_route_table.rnd_rt.id
}

resource "aws_subnet" "rnd_subnet" {
  vpc_id            = aws_vpc.rnd_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "rnd-subnet-example"
  }
}

resource "aws_network_interface" "rnd_network" {
  subnet_id       = aws_subnet.rnd_subnet.id
  security_groups = [aws_security_group.RND-SG.id]

  tags = {
    Name = "primary_network_interface"
  }
}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-resolute-26.04-amd64-server-*"]
    # /aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id
    # amazon/ubuntu/images/hvm-ssd-gp3/ubuntu-resolute-26.04-amd64-server-20260421
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_eip" "rnd_eip" {
  instance = aws_instance.RND_EC2.id
  domain   = "vpc"

  tags = {
    Name = "RND_EIP"
  }
}



resource "aws_instance" "RND_EC2" {
  # ami           = "ami-02c4808b9f729b235"  # us-east-1
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name       = "MYLABKEY"

  
instance_market_options {
    market_type = "spot"
    spot_options {
      max_price = 0.0037
    }
  }

  tags = { Name = "Spot_EC2_RND" }
 
 root_block_device {
    volume_size = 10
  }

  primary_network_interface {
    network_interface_id = aws_network_interface.rnd_network.id
  }

  credit_specification {
    cpu_credits = "unlimited"
  }
}



resource "aws_security_group" "RND-SG" {
  name        = "Allowed Requeted Port Group for Spot Instance"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.rnd_vpc.id

  ingress {
    description = "SSH Allowed"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

