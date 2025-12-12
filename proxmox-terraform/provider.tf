# provider.tf
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.14"
    }
  }
}

provider "proxmox" {
  pm_tls_insecure = true
  pm_api_url      = "https://192.168.0.98:8006/api2/json"
  pm_password     = var.proxmox_password
  pm_user         = "terraform@pve"
  pm_timeout      = 3600
}