provider "aws" {
        region  = "us-east-1"
     # access_key = "Type your access key here"
        # secret_key = "type your secret key here"
     profile = "terraformlab"

}

resource "aws_instance" "FIRST_TERRAFORM_INSTANCE" {
  ami           =  "ami-091138d0f0d41ff90"  # Ubuntu AMI
  instance_type = "t2.micro"
  count         = "1"
  tags = {
    Name = "TERRAFORM-1"
  }
}
