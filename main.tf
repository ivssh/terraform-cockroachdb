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

resource "null_resource" "bastion-runner" {

  depends_on = [null_resource.cockroach-runner]

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("~/.ssh/yulu_assignment.pem")}"
    host = "${aws_eip.bastion_eip.public_ip}"
  }

  provisioner "file" {
    source = "download_binary.sh"
    destination = "/home/ubuntu/download_binary.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install nethogs",
      "mkdir -p logs",
      "chmod 755 cockroach",
      "[ $(stat --format=%s cockroach) -ne 0 ] || sudo bash download_binary.sh cockroach/cockroach ${var.cockroach_sha}",
      "cockroach init --insecure --host=${aws_instance.roach_instance[0].private_ip}"
    ]
  }
}

resource "null_resource" "cockroach-runner" {
  count = "${var.num_of_instances}"

  depends_on = [aws_eip.bastion_eip]

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("~/.ssh/yulu_assignment.pem")}"
    host = "${element(aws_instance.roach_instance.*.private_ip, count.index)}"
    bastion_host = "${aws_eip.bastion_eip.public_ip}"
    bastion_user = "ubuntu"
    bastion_private_key = "${file("~/.ssh/yulu_assignment.pem")}"
  }

  provisioner "file" {
    source = "download_binary.sh"
    destination = "/home/ubuntu/download_binary.sh"
  }

  provisioner "file" {
    # If no binary is specified, we'll copy /dev/null (always 0 bytes) to the
    # instance. The "remote-exec" block will then overwrite that. There's no
    # such thing as conditional file copying in Terraform, so we fake it.
    source = "${coalesce(var.cockroach_binary, "/dev/null")}"
    destination = "/home/ubuntu/cockroach"
  }

  # Launch CockroachDB.
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install nethogs",
      "mkdir -p logs",
      "chmod 755 cockroach",
      "[ $(stat --format=%s cockroach) -ne 0 ] || sudo bash download_binary.sh cockroach/cockroach ${var.cockroach_sha}",
      "cockroach start --insecure --advertise-addr=${element(aws_instance.roach_instance.*.private_ip, count.index)} --join=${join(",", aws_instance.roach_instance.*.private_ip)} --cache=.25 --max-sql-memory=.25 --background"
    ]
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