variable "instance_type" {
  default = "m7i-flex.large"
}

variable "key_name" {
  default = "mumbaikeypair" # Change this to your .pem key name
}

variable "my_ip" {
  default = "106.215.150.20/32" # This matches your screenshot
}
