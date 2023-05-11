variable "pm_user" {
    default = "admin"
}

variable "pm_password" {
    default = "admin"
}

provider "proxmox" {
    pm_api_url = "https://192.168.100.2:8006/api2/json"
}

resource "proxmox_vm_qemu" "win10_vm" {
    count = 4

    name = "wintest${count.index + 1}"
    description = "Windows 10 test VM ${count.index + 1}"
    target_node = "r730"
    os_type = "win10"
    sockets = 1
    core = 4
    memory = "4096"
    scsihw = "virtio-scsi-pci"
    storage = "local"
    template_name = ""
    scsi_controller {
        model = "virtio-scsi-pci"
    }

    disk {
        size = "50G"
        type = "virtio"
    }

    network_interface {
        model = "virtio"
        bridge = "vmbr0"
        ip = "192.168.1.${count.index + 2}"
    }
    bootdisk = "scsi0"

    provisioner "remote-exec" {
        inline = [
            "echo 'Hello!' > C:\\hello.txt"
        ]
    }
}
