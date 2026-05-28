provider "aws" {
        region  = "us-east-1"
        # access_key = "Type your access key here"
        # secret_key = "type your secret key here"
        profile = "terraformlab"
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


resource "aws_instance" "example" {
  ami = data.aws_ami.ubuntu.id
  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price = 0.0031
    }
  }
  instance_type = "t4g.nano"
  tags = {
    Name = "test-spot"
  }
}
