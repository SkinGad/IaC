data "local_file" "ssh_public_key" {
  filename = "/home/filin/.ssh/id_rsa.pub"
}

resource "proxmox_virtual_environment_file" "cloud_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "srv-px2"

  source_raw {
    data = <<-EOF
    #cloud-config
    runcmd:
        - apt update
        - apt install -y qemu-guest-agent
        - timedatectl set-timezone Asia/Yekaterinburg
        - systemctl enable qemu-guest-agent
        - systemctl start qemu-guest-agent
        - echo "done" > /tmp/cloud-config.done
    EOF
    file_name = "cloud-config.yaml"
  }
}