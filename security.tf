# setup EC2 instance security group"
resource "aws_security_group" "SkyDemo-ssh-http" {
  name        = "SkyDemo-ssh-http"
  description = "allow ssh and http traffic"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow ssh access from Subhash IP only"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
    description = "Allow ssh access from servers on local LAN"
  }

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow http access from Subhash IP and the load balancer"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow All outgoing access"
  }


  tags = {
    Name = "Project-SkyDemo"
  }

}

# set load balancer security group along with access rules

resource "aws_security_group" "SkyDemo-elbsg" {
  name        = "SkyDemo-elbsg"
  description = "allow http traffic"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["Your Ext IP/32"]
    description = "Allow 443 access from Subhash IP"
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow All outgoing access"
  }

  tags = {
    Name = "Project-SkyDemo"
  }
}

