# author: Subhash Rehan

# create EC2 instance on default subnet and do some post build tasks
resource "aws_instance" "SkyDemo" {
  ami               = var.ami
  instance_type     = var.instance_type
  availability_zone = "us-east-1a"
  security_groups   = ["${aws_security_group.SkyDemo-ssh-http.name}"]
  key_name          = aws_key_pair.skydemo_key.key_name
  associate_public_ip_address = "true"

  tags = {
    Name = "Template-SkyDemo"
  }

}

# call ansible to install  & configure httpd

resource "null_resource" "httpd_deploy" {
  provisioner "local-exec" {
    command = "sleep 200;ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -T 300 -i ${aws_instance.SkyDemo.public_ip}, --user centos --private-key skydemo.pem playbook.yml"
  }

  depends_on = [aws_instance.SkyDemo]
}

resource "aws_ami_from_instance" "ami-skydemo" {
  name               = "web-skydemo"
  source_instance_id = aws_instance.SkyDemo.id

  depends_on = [null_resource.httpd_deploy]
}

resource "aws_instance" "SkyDemoweb" {
  count         = 2
  ami           = aws_ami_from_instance.ami-skydemo.id
  instance_type = var.instance_type
  availability_zone = var.availability-zones[count.index]
  security_groups             = ["${aws_security_group.SkyDemo-ssh-http.name}"]
  key_name                    = aws_key_pair.skydemo_key.key_name
  associate_public_ip_address = "false"

  tags = {
    Name = "web-SkyDemo"
  }

}

# create simple classic load balancer

resource "aws_elb" "SkyDemo-elb" {
  name = "SkyDemo-elb"
  availability_zones = var.availability-zones
  security_groups    = ["${aws_security_group.SkyDemo-elbsg.id}"]
  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 443
    lb_protocol       = "https"
    ssl_certificate_id = aws_acm_certificate.cert.id
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "tcp:8080"
    interval            = 30
  }
  #  instances                   = ["${aws_instance.SkyDemo.id}"]
  instances                   = [aws_instance.SkyDemoweb[0].id, aws_instance.SkyDemoweb[1].id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "Project-SkyDemo"
  }
}
