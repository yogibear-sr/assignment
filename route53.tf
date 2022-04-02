# create web server DNS record pointing to load balancer

resource "aws_route53_zone" "skydemo" {
  name = "skydemo1234"
}

resource "aws_route53_record" "srehan-httpd" {
  zone_id = aws_route53_zone.skydemo.zone_id
  name    = "www.skydemo12345.com"
  type    = "A"

  alias {
    name                   = aws_elb.SkyDemo-elb.dns_name
    zone_id                = aws_elb.SkyDemo-elb.zone_id
    evaluate_target_health = true
  }
}
