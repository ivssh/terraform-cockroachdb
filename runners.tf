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