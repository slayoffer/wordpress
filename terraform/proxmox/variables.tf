variable "pm_api_token_secret" {
  description = "The API token secret for Proxmox"
  type        = string
  sensitive   = true
}

variable "pm_api_token_id" {
  description = "The API token ID for Proxmox"
  type        = string
  sensitive   = true
}

variable "pm_api_url" {
  description = "The API URL for Proxmox"
  type        = string
  sensitive   = true
}