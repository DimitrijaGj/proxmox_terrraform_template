terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.61"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure = true  # if using self-signed certificates
}

locals {

  types = {

    small = {
      cpu_cores = 2
      cpu_type = "host"
      mem_mb = 2048
      disk_gb = 32
    }

    medium = {
      cpu_cores = 4
      cpu_type = "host"
      mem_mb = 4096
      disk_gb = 50
    }

    large = {
      cpu_cores = 8
      cpu_type = "host"
      mem_mb = 16384
      disk_gb = 100
    }
  }
  choice = local.types[var.vm_type]
}

resource "proxmox_virtual_environment_vm" "foo-machine" {
  node_name = "gjoshevi"
  vm_id     = var.vm_id
  name      = var.vm_name
  
  cpu {
    cores = local.choice.cpu_cores
    type  = local.choice.cpu_type
  }
  
  memory {
    dedicated = local.choice.mem_mb
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = local.choice.disk_gb
    file_format  = "raw"
  }
  
  network_device {
    bridge = "vmbr0"
  }
  
  clone {
    vm_id = var.template_id
    full = true
  }
  initialization {
    interface = "ide2"
    type = "nocloud"
  }

}
