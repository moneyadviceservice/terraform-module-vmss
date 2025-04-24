variable "vmss_name" {
  type        = string
  default     = "devops-vmss"
  description = "vmss name"
}

variable "location" {
  type        = string
  default     = "uksouth"
  description = "vmss location"
}

variable "vmss_source_image_id" {
  type        = string
  description = "vmss source image id"
}

variable "resource_group_name" {
  type        = string
  description = "resource group name"
}

variable "vmss_sku" {
  type        = string
  default     = "Standard_B1s"
  description = "vmss sku"
}

variable "vmss_instance_count" {
  type        = number
  default     = 1
  description = "vmss instance count"
}

variable "vmss_admin_username" {
  type        = string
  default     = "azureuser"
  description = "vmss admin username"
}

variable "automatic_os_upgrade_policy" {
  type = ""
}

variable "tags" {
  type        = map(string)
  description = "The tags to apply to the virtual Machine Scale Set and associated resources."
}

variable "vm_publisher_name" {
  type        = string
  default     = "Canonical"
  description = "vm publisher name"
}

variable "vm_offer" {
  type        = string
  description = "The offer of the marketplace image to use."
}

variable "vm_image_sku" {
  type        = string
  description = "The SKU of the image to use."
}

variable "vm_version" {
  type        = string
  description = "The version of the image to use."
}

variable "vm_type" {
  type        = string
  description = "The type of the vm scale set, either windows or linux"
  validation {
    condition     = contains(["windows", "linux"], lower(var.vm_type))
    error_message = "Unknown VM type. Must be either 'windows' or 'linux'"
  }
}

variable "vm_admin_password" {
  type        = string
  sensitive   = true
  description = "The Admin password for the virtual Machine Scale Set."
}

variable "vm_availabilty_zones" {
  type        = list(any)
  description = "The availability zones to deploy the VM in"
}

variable "custom_data" {
  type        = string
  description = "Custom data to pass to the virtual machine."
  default     = null
}
