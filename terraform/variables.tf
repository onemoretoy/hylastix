variable "admin_username" {
  type        = string
  description = "Admin username for the VM"
  default     = "hylastix-admin"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path to SSH public key"
  default     = "~/.ssh/hylastix_vm_key.pub"
}