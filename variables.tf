variable "proxmox_endpoint" {
	description = "Proxmox API Endpoint"
	type = string
	sensitive = true
}

variable "proxmox_api_token" {
	description = "Proxmox API Token"
	type = string
	sensitive = true 
}

variable "vm_name" {
  description = "Name of the VM"
  type = string
  default = "clone-machine"
}

variable "vm_id" {
  description = "Man ual add -var 'vm_id = int'. If not the next free ID will be assigned!!!"
  type = number
  nullable = true
  default = null
}

variable "vm_type" {
  description = "What size of VM we create (small, medium, large)"
  type = string
  default = "medium"
  validation {
    condition = contains (["small", "medium", "large"], var.vm_type)
    error_message = "VM Type must be small, medium or large"
  }
}
variable "template_id" {
  description = "VM ID of the template to clone from"
  type = number
  default = 103
}
