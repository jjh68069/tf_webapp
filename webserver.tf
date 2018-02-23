resource "aws_launch_configuration" "webserver" {
  image_id = "ami-965e6bf3"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.webserver.id}"]
  
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "webserver" {
  launch_configuration = "${aws_launch_configuration.webserver.id}"
  availability_zones = ["${data.aws_availability_zones.all.names}"]

  load_balancers = ["${aws_elb.balancer.name}"]
  health_check_type = "ELB"

  min_size = 2
  max_size = 3

  tag {
    key = "Name"
    value = "webserver"
    propagate_at_launch = true
  }
}

resource "aws_elb" "balancer" {
  name = "terraform-asg-example"
  security_groups = ["${aws_security_group.elb.id}"]
  availability_zones = ["${data.aws_availability_zones.all.names}"]

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:${var.server_port}/"
  }

  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "${var.server_port}"
    instance_protocol = "http"
  }
}

resource "aws_security_group" "elb" {
  name = "terraform-example-elb"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "webserver" {
  name = "ws-security"

  ingress {
    from_port = "${var.server_port}"
    to_port = "${var.server_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_availability_zones" "all" {}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default = 8080
}

output "elb_dns_name" {
  value = "${aws_elb.balancer.dns_name}"
}

