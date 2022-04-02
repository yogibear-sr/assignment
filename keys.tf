# create ssh keys

resource "tls_private_key" "skydemo" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "skydemo_key" {
  key_name   = var.key_name
  public_key = tls_private_key.skydemo.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.skydemo.private_key_pem}' > ./skydemo.pem"
  }

  provisioner "local-exec" {
    command = "chmod 400 ./skydemo.pem"
  }
}


