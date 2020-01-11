# Tagging for resources
variable "tag" {
  default = "static-demo-sa01web-v2"
}

# Region & Zones
variable "region" {
  default = "us-east-1"
}

variable "zone" {
  default = "us-east-1a"
}

variable "all_ip" {
  type = "list"
  default = ["0.0.0.0/0"]
}
