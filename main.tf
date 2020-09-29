provider "aws" {
  version = "~> 3.0"
  region  = "ap-south-1"
}



resource "aws_instance" "roach_instance" {
  count = "${var.num_of_instances}"
  ami                    = "ami-009110a2bf8d7dd0a"
  instance_type          = "t3.large"
  subnet_id              = "${aws_subnet.private_subnet_1.id}"
  vpc_security_group_ids = ["${aws_security_group.roach_sg.id}"]
  key_name               = "${aws_key_pair.deployment.key_name}"

  tags = {
    Name        = "${terraform.workspace} Roach instance ${count.index}"
    Environment = "${terraform.workspace}"
    Creator     = "Terraform"
  }
}

resource "aws_instance" "bastion_instance" {
  ami                    = "ami-009110a2bf8d7dd0a"
  instance_type          = "t3.micro"
  subnet_id              = "${aws_subnet.public_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.bastion_sg.id}"]
  key_name               = "${aws_key_pair.deployment.key_name}"

  tags = {
    Name        = "${terraform.workspace} bastion instance"
    Environment = "${terraform.workspace}"
    Creator     = "Terraform"
  }
}

resource "aws_eip" "bastion_eip" {
  instance = aws_instance.bastion_instance.id

  tags = {
    "Name" = "Bastion Elastic IP"
  }
}