terraform {
  required_version = "v1.9.3"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.61.1" # x-release-please-version
    }
  }
}

provider "proxmox" {
  username = "terraform@pve"
  password = "secret"
  endpoint = "https://10.0.10.40:8006/"
  # endpoint = "https://px2.gkregion72.ru/"
  min_tls  = 1.2
  insecure = true
  ssh {
    agent       = true
    username    = "root"
    password    = "secret"
    private_key = "secret"
  }
}
