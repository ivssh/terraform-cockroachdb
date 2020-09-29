resource "aws_lb" "roach_lb" {
  name               = "${terraform.workspace}-roach-service-lb"
  internal           = true
  load_balancer_type = "network"
  subnets            = ["${aws_subnet.private_subnet_1.id}", "${aws_subnet.private_subnet_2.id}"]

  enable_deletion_protection = false

  # access_logs {
  #   bucket  = "${aws_s3_bucket.alb_access_logs.bucket}"
  #   prefix  = "roach-lb"
  #   enabled = false
  # }

  tags = {
	Name = "${terraform.workspace} Roach Service Load Balancer"
    Environment = "${terraform.workspace}"
    Creator     = "Terraform"
  }
}

resource "aws_alb_listener" "roach_service_listener" {
  load_balancer_arn = "${aws_lb.roach_lb.arn}"
  port              = "26257"
  protocol          = "TCP"
  
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.roach_service_tg.arn}"
  }
}

resource "aws_lb_target_group" "roach_service_tg" {
  name     = "${terraform.workspace}-roach-service"
  port     = 26257
  protocol = "TCP"
  vpc_id   = "${aws_vpc.vpc.id}"

  health_check {
    path = "/health?ready=1"
    port = 8080
    protocol = "HTTP"
  }
}

# resource "aws_s3_bucket" "alb_access_logs" {
# 	bucket = "${lower(terraform.workspace)}-epifi-assignment-alb-logs"
#   acl    = "public-read"

#   tags = {
#     Name        = "${terraform.workspace} ALB Bucket"
#     Environment = "${terraform.workspace}"
#   }
# }

# resource "aws_s3_bucket_policy" "b" {
#   bucket = "${aws_s3_bucket.alb_access_logs.id}"

#   policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "AWS": "arn:aws:iam::718504428378:root"
#       },
#       "Action": "s3:PutObject",
#       "Resource": "arn:aws:s3:::${aws_s3_bucket.alb_access_logs.bucket}/*"
#     }
#   ]
# }
# POLICY
# }

resource "aws_lb_target_group_attachment" "roach_service_tg_attachment" {
  count = 3
  target_group_arn = "${aws_lb_target_group.roach_service_tg.arn}"
  target_id        = "${element(aws_instance.roach_instance.*.id, count.index)}"
  port             = 26257
}