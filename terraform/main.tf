resource "proxmox_virtual_environment_vm" "test_debian_vm" {
  count     = 1
  name      = "test-debian-${count.index + 1}"
  node_name = "srv-px2"
  tags      = ["test", "linux"]
  migrate   = true
  clone {
    vm_id = 500
  }

  agent {
    enabled = true
  }

  initialization {
    datastore_id = "md0"

    ip_config {
      ipv4 {
        # address = "dhcp"
        address = "10.10.12.9${count.index + 1}/24"
        gateway = "10.10.12.1"
      }
    }

    user_account {
      username = var.username
      keys     = [trimspace(data.local_file.ssh_public_key.content)]
    }
  }

  disk {
    datastore_id = "md0"
    interface    = "scsi0"
    size         = 20
  }

  network_device {
    bridge = "vmbr0"
  }

  cpu {
    cores   = 2
    sockets = 1
    type    = "kvm64"
  }
  memory {
    dedicated = 2048
  }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo killall apk pak-get",
  #     "sudo apt-get update",
  #     "sudo apt-get install -y -f qemu-guest-agent",
  #     "sudo systemctl start qemu-guest-agent"
  #   ]
  #   connection {
  #     type        = "ssh"
  #     host        = "10.10.12.9${count.index+1}"
  #     private_key = "${file("~/.ssh/id_rsa")}"
  #     user        = "filin"
  #   }
  # }
}
output "vm_ipv4_address" {
  value = [for vm in proxmox_virtual_environment_vm.test_debian_vm :
    vm.ipv4_addresses[index(vm.network_interface_names, "eth0")][0]
  ]
}

resource "null_resource" "write_inventory_file" {
  provisioner "local-exec" {
    command = <<EOF
      terraform output -json vm_ipv4_address | jq -r '.[]' > output.txt
      EOF
  }
}

