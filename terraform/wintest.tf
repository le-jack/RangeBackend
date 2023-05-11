terraform {
    required_providers {
        proxmox = {
            source = "telmate/proxmox"
            version = "2.9.14"
        }
    }
}

variable "PM_USER" {
    default = "admin"
}

variable "PM_PASSWORD" {
    default = "admin"
}

provider "proxmox" {
    pm_api_url = "https://192.168.100.2:8006/api2/json"
    pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "win10_vm" {
    count = 4

    name = "wintest${count.index + 1}"
    target_node = "r730"
    iso = "win10-desktop"
    os_type = "win10"
    sockets = 2
    cores = 4
    memory = "4096"
    scsihw = "virtio-scsi-pci"

    disk {
        size = "50G"
        type = "virtio"
        storage = "local"
    }

    network {
        model = "virtio"
        bridge = "vmbr0"
    }
    bootdisk = "scsi0"

    provisioner "remote-exec" {
        inline = [
            "echo 'Hello!' > C:\\hello.txt"
        ]
    }
}
