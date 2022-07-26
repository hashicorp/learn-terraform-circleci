provider "aws" {
  region = "us-east-1"

}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "MainVPC"
  }
}

resource "aws_instance" "myinstance" {
  ami           = "ami-0d5eff06f840b45e9"
  instance_type = "t2.micro"
  count         = 2
  tags = {
    Name  = "WebServers",
    Group = "Database"
  }

}
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
  }
}
