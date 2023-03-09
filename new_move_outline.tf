terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.27.1"
    }
  }
}

variable "ssh_key_path" {}
variable "fingerprint" {}
variable "token" {}


data "hcloud_ssh_key" "ssh_key" {
  fingerprint = var.fingerprint
}

provider "hcloud" {
  token = var.token
}

resource "hcloud_server" "new" {
  name        = "outine-new-2.5"
  server_type = "cx21"
  image       = "ubuntu-20.04"
  ssh_keys  = ["${data.hcloud_ssh_key.ssh_key.id}"]
  labels      = {
    "app" = "outline"
    "env" = "new"
  }
}

output "new_server_ip" {
  value = hcloud_server.new.ipv4_address
}
