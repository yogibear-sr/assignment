resource "tls_private_key" "key" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "cert" {
  key_algorithm         = "RSA"
  private_key_pem       = tls_private_key.key.private_key_pem
  validity_period_hours = 87600

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]

  dns_names = ["*.${var.aws_region}.elb.amazonaws.com"]

  subject {
    common_name  = "*.${var.aws_region}.elb.amazonaws.com"
    organization = "ORAG"
    province     = "STATE"
    country      = "COUNT"
  }
}

resource "aws_acm_certificate" "cert" {
  private_key      = tls_private_key.key.private_key_pem
  certificate_body = tls_self_signed_cert.cert.cert_pem
}

