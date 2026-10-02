packer {
  required_plugins {
    windows-update = {
      version = ">= 0.18.5"
      source = "github.com/rgl/windows-update"
    }
    qemu = {
      version = ">= 1.1.7"
      source  = "github.com/hashicorp/qemu"
    }
    alicloud = {
      version = ">= 1.2.0"
      source  = "github.com/hashicorp/alicloud"
    }
    proxmox = {
      version = ">= 1.2.4"
      source  = "github.com/hashicorp/proxmox"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = ">= 1.1.6"
    }
    vagrant = {
      source  = "github.com/hashicorp/vagrant"
      version = ">= 1.1.7"
    }
  }
}
