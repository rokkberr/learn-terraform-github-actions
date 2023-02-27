data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  #owners = ["099720109477"] # Canonical
}

resource "aws_instance" "app_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.TF_DMZ1.id

  tags = {
    Name = "TZ-DMZ-Server"
  }
}

resource "aws_instance" "db_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  associate_public_ip_address = false
  subnet_id                   = aws_subnet.TF_Secure1.id

  tags = {
    Name = "TZ-Secure-Server"
  }
}

