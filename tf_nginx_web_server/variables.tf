variable "username" {
    description = "Username for the VM"
    type        = string
    sensitive   = true
    default     = ""  #Declare here for ease #IMPORTANT! always delete before push to Github
}

variable "password" {
    description = "Password for the VM"
    type        = string
    sensitive   = true
    default = "" #Declare here for ease #IMPORTANT! always delete before push to Github
}

variable "publicip" {
    description = "Public IP for the VM"
    type        = string
    sensitive   = true
    default     = "" #Declare here for ease #IMPORTANT! always delete before push to Github
}
