provider "aws" {
  region = var.region
}

resource "aws_vpc" "mf_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "mf_vpc"
    environment = var.environment
  }
}

resource "aws_subnet" "mf_public_subnet" {
  vpc_id            = aws_vpc.mf_vpc.id
  cidr_block        = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

  tags = {
    Name = "mf_public_subnet"
    environment = var.environment
  }
}

resource "aws_security_group" "mf_sg" {
  name        = "mf_sg"
  description = "Security group for mini finance project"
  vpc_id      = aws_vpc.mf_vpc.id

  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    description = "Allow SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    egress {
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_internet_gateway" "mf_igw" {
  vpc_id = aws_vpc.mf_vpc.id

  tags = {
    Name = "mf_igw"
    environment = var.environment
  }
}
 
resource "aws_route_table" "mf_public_rt" {
  vpc_id = aws_vpc.mf_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mf_igw.id
  }
}

resource "aws_route_table_association" "mf_rt_assoc" {
  subnet_id      = aws_subnet.mf_public_subnet.id
  route_table_id = aws_route_table.mf_public_rt.id
}

resource "aws_subnet" "mf_private_subnet" {
  vpc_id            = aws_vpc.mf_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "mf_private_subnet"
    environment = var.environment
  }
}

resource "aws_route_table" "mf_private_rt" {
  vpc_id = aws_vpc.mf_vpc.id
    tags = {
        Name = "mf_private_rt"
        environment = var.environment
    }
}

resource "aws_route_table_association" "mf_private_rt_assoc" {
  subnet_id      = aws_subnet.mf_private_subnet.id
  route_table_id = aws_route_table.mf_private_rt.id
}

resource "aws_key_pair" "ansible_key" {
    key_name   = "ansible_key"
    public_key = file("~/.ssh/ansible_ec2.pub")
}

resource "aws_instance" "EC2_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.mf_public_subnet.id
  vpc_security_group_ids = [aws_security_group.mf_sg.id]
  associate_public_ip_address = true
  key_name               = aws_key_pair.ansible_key.key_name

  tags = {
    Name = "Mini-Finance-Server"
    environment = var.environment
  }
}