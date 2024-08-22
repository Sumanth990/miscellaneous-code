terraform {
  backend "s3" {
    bucket = "d77-terraform1"
    key    = "misc/prometheus/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_ami" "centos08" {
  most_recent = true
  name_regex  = "Centos-8-DevOps-Practice"
  owners      = ["973714476881"]
}

resource "aws_instance" "prometheus" {
  ami           = data.aws_ami.centos08.id
  instance_type = "t3.small"
  vpc_security_group_ids = ["sg-0707042aa4428149b"]

  tags = {
    Name = "Prometheus server"
  }
}

resource "aws_route53_record" "prometheus" {
  zone_id = "Z039456039ZR7HLJXDP8U"
  name    = "prometheus"
  type    = "A"
  ttl     = 30
  records = [aws_instance.prometheus.private_ip]
}