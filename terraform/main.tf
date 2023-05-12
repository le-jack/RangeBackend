terraform {
    required_providers {
        proxmox = {
            source = "telmate/proxmox"
            version = "2.9.14"
        }
    }
}

variable "PM_USER" {
    type = string
}

variable "PM_PASSWORD" {
    type = string
}

provider "proxmox" {
    pm_tls_insecure = true
    pm_api_url = "https://192.168.100.2:8006/api2/json"
    pm_user = var.PM_USER 
    pm_password = var.PM_PASSWORD

}

resource "proxmox_vm_qemu" "win10_template_vm" {
    count = 4

    name = "wintest${count.index + 1}"
    target_node = "r730"
    iso = "local:iso/windo10raw.iso"
    os_type = "win10"
    sockets = 2
    cores = 4
    memory = "4096"
    scsihw = "virtio-scsi-pci"

    disk {
        size = "50G"
        type = "scsi"
        storage = "local-lvm"
    }

    network {
        model = "virtio"
        bridge = "vmbr2"
    }
    bootdisk = "scsi0"

    provisioner "remote-exec" {
        inline = [
            "echo 'Hello!' > C:\\hello.txt"
        ]
    }
}
