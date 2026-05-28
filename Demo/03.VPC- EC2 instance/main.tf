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

resource "aws_subnet" "rnd_subnet" {
  vpc_id            = aws_vpc.rnd_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "rnd-subnet-example"
  }
}

resource "aws_network_interface" "rnd_network" {
  subnet_id   = aws_subnet.rnd_subnet.id
  private_ips = ["172.16.10.100"]

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


resource "aws_instance" "RND_EC2" {
 # ami           = "ami-02c4808b9f729b235"  # us-east-1
   ami  = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

   tags = {Name = "BALRAJ_EC2_RND"}

  network_interface {
    network_interface_id = aws_network_interface.rnd_network.id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }
}
