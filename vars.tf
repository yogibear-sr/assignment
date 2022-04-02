variable "ami" {
  default = "ami-0d6e9a57f6259ba3a"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "availability-zones" {
  default = [
    "us-east-1a",
    "us-east-1b",
  ]
  type = list(any)
}


variable "instance_counter" {
  description = "Number of EC2 instances"
  default     = 1
}

variable "key_name" {
  default = "skydemo"
}

variable "public_key" {
  default = "skydemo.pub"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default     = 8080
}

variable "ssh_port" {
  default = 22
}

