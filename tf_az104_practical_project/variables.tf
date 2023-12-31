variable "vm_host_username" {
  description = "Username for hypervisor 01"
  type        = string
  sensitive   = true
  default     = "" #Declare here for ease #IMPORTANT! always delete before push to Github
}

variable "vm_host_password" {
  description = "password for hypervisor 01"
  type        = string
  sensitive   = true
  default     = "" #Declare here for ease #IMPORTANT! always delete before push to Github
}

variable "mypublicip" {
  description = "Public IP for the VM"
  type        = string
  sensitive   = true
  default     = "" #Declare here for ease #IMPORTANT! always delete before push to Github
}

variable "tags" {
  description = "Tags for the VM"
  type        = map(string)
  default = {
    Environment = "tf_az104_practical_project"
  }
}

variable "uks" {
  description = "Azure UK South Region Name"
  type        = string
  default     = "uksouth"
}