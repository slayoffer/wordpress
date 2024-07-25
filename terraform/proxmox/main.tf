resource "proxmox_vm_qemu" "pfsense" {
    target_node = "pve"
    desc = "Pfsense Gateway"
    vmid = 106
    count = 1
    onboot = true
    agent = 0
    cores = 1
    sockets = 1
    numa = false
    vcpus = 0
    cpu = "host"
    memory = 1024
    name = "pfsense-node-0${count.index + 1}"
    iso = "local:iso/pfSense-CE-2.7.2-RELEASE-amd64.iso"
    scsihw   = "virtio-scsi-single" 
    bootdisk = "scsi0"

    disks {
        scsi {
            scsi0 {
                disk {
                  storage = "local"
                  size = 22
                }
            }
        }
    }

    network {
        bridge    = "vmbr0"
        firewall  = false
        link_down = false
        model     = "virtio"
        tag       = 3
        queues    = 8
    }

}

resource "proxmox_vm_qemu" "cloudinit-nginx" {
    target_node = "pve"
    desc = "Cloudinit Ubuntu"
    count = 1
    onboot = true
    clone = "ubuntu-cloud"
    agent = 1
    os_type = "cloud-init"
    cores = 1
    sockets = 1
    numa = false
    vcpus = 0
    cpu = "host"
    memory = 512
    name = "nginx-node-${count.index + 1}"
    cloudinit_cdrom_storage = "local"
    scsihw   = "virtio-scsi-single" 
    bootdisk = "scsi0"

    network {
        bridge    = "vmbr99"
        firewall  = false
        link_down = false
        model     = "virtio"
        tag       = 10
    }

    disks {
        scsi {
            scsi0 {
                disk {
                  storage = "local"
                  size = 22
                }
            }
        }
    }

    # cloud init settings
    # ipconfig0 = "ip=192.168.99.15${count.index + 1}/24,gw=192.168.99.1"
    ciuser = "ubuntu"
    # nameserver = "192.168.99.1"
    sshkeys = <<EOF
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMnXVi4TmZa1WQ1mnk8eZACQhIIivz/7Yh2TUhrYC1gK broz
    EOF
}

resource "proxmox_vm_qemu" "cloudinit-wordpress-master" {
    target_node = "pve"
    desc = "Cloudinit Ubuntu"
    # vmid = 100
    count = 1
    onboot = true
    clone = "ubuntu-cloud-24-04"
    agent = 1
    os_type = "cloud-init"
    cores = 2
    sockets = 1
    numa = false
    vcpus = 0
    cpu = "host"
    memory = 2048
    name = "wordpress-master-node-${count.index + 1}"
    cloudinit_cdrom_storage = "local"
    scsihw   = "virtio-scsi-single" 
    bootdisk = "scsi0"

    network {
        bridge    = "vmbr99"
        firewall  = false
        link_down = false
        model     = "virtio"
        tag       = 10
    }

    disks {
        scsi {
            scsi0 {
                disk {
                  storage = "local"
                  size = 22
                }
            }
        }
    }

    # ipconfig0 = "ip=192.168.3.16${count.index + 1}/24,gw=192.168.3.1"
    ciuser = "ubuntu"
    # cipassword = "123456"
    # nameserver = "192.168.3.68"
    # sshkeys = file("~/.ssh/broz_key.pub")
    sshkeys = <<EOF
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMnXVi4TmZa1WQ1mnk8eZACQhIIivz/7Yh2TUhrYC1gK broz
    EOF
}

resource "proxmox_vm_qemu" "cloudinit-wordpress-worker" {
    target_node = "pve"
    desc = "Cloudinit Ubuntu"
    count = 2
    onboot = true
    clone = "ubuntu-cloud-24-04"
    agent = 1
    os_type = "cloud-init"
    cores = 1
    sockets = 1
    numa = true
    vcpus = 0
    cpu = "host"
    memory = 2048
    name = "worpress-worker-node-${count.index + 1}"
    cloudinit_cdrom_storage = "local"
    scsihw   = "virtio-scsi-single" 
    bootdisk = "scsi0"

    network {
        bridge    = "vmbr99"
        firewall  = false
        link_down = false
        model     = "virtio"
        tag       = 10
    }

    disks {
        scsi {
            scsi0 {
                disk {
                  storage = "local"
                  size = 22
                }
            }
        }
    }

    # ipconfig0 = "ip=192.168.3.17${count.index + 1}/24,gw=192.168.3.1"
    ciuser = "ubuntu"
    # nameserver = "192.168.3.68"
    sshkeys = <<EOF
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMnXVi4TmZa1WQ1mnk8eZACQhIIivz/7Yh2TUhrYC1gK broz
    EOF
}