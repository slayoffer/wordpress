terraform {
  required_version = ">= 1.7.1"

  required_providers {
    proxmox = {
      source  = "registry.example.com/telmate/proxmox"
      version = ">= 1.0.0"
      # source  = "Telmate/proxmox"
      # version = ">= 3.0.1-rc1"
    }
  }
}

provider "proxmox" {
  # pm_tls_insecure = true
  # pm_api_url = "https://192.168.1.82:8006/api2/json"
  pm_api_url = var.pm_api_url
  pm_api_token_secret = var.pm_api_token_secret
  pm_api_token_id = var.pm_api_token_id

  pm_debug = true
  pm_log_levels = {
    _default    = "debug"
    _capturelog = ""
  }
}