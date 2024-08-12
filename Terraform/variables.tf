variable "resource-group" {
  type        = string
  description = "The name of the sandbox resource group."
}

variable "timezone" {
  type        = string
  description = "The timezone of the lab VMs."
  default     = "W. Europe Standard Time"
}

variable "ip-whitelist" {
  description = "A list of CIDRs that will be allowed to access the exposed services."
  type        = list(string)
}

variable "domain-name-label" {
  description = "The DNS name of the Azure public IP."
  type        = string
  default     = "cloudlabs"
}

variable "domain-dns-name" {
  description = "The DNS name of the Active Directory domain."
  type        = string
  default     = "cloud.labs"
}

variable "hackbox-hostname" {
  type = string
  description = "The hostname of the attacker VM."
  default = "hackbox"
}

variable "hackbox-size" {
  type = string
  description = "The machine size of the attacker VM."
  default = "Standard_B4ms"
}

variable "splunk-hostname" {
  type = string
  description = "The hostname of the splunk VM."
  default = "splunk"
}

variable "splunk-size" {
  type = string
  description = "The machine size of the splunk VM."
  default = "Standard_B4ms"
}

variable "dc-hostname" {
  type = string
  description = "The hostname of the Windows Server 2016 DC VM."
  default = "dc"
}

variable "dc-size" {
  type = string
  description = "The machine size of the Windows Server 2016 DC VM."
  default = "Standard_B4ms"
}

variable "win10xdr-hostname" {
  type = string
  description = "The hostname of the Windows 10 VM."
  default = "win10"
}

variable "win10xdr-size" {
  type = string
  description = "The machine size of the Windows 10 VM."
  default = "Standard_B4ms"
}

variable "win10def-hostname" {
  type = string
  description = "The hostname of the Windows 10 VM."
  default = "win10"
}

variable "win10def-size" {
  type = string
  description = "The machine size of the Windows 10 VM."
  default = "Standard_B4ms"
}

variable "syslog-hostname" {
  type = string
  description = "The hostname of the syslog"
  default = "syslog"
}

variable "syslog-size" {
  type = string
  description = "The machine size of the syslog"
  default = "Standard_B4ms"
}

variable "linux-hostname" {
  type = string
  description = "The hostname of the linux VM."
  default = "linux"
}

variable "linux-size" {
  type = string
  description = "The machine size of the linux"
  default = "Standard_B4ms"
}

variable "windows-user" {
  type        = string
  description = "The local administrative username for Windows machines. Password will be generated."
  default     = "labadmin"
}  

variable "syslog-user" {
  type        = string
  description = "The local administrative username for syslog machines. Password will be generated."
  default     = "labadmin"
}  

variable "splunk-user" {
  type        = string
  description = "The local administrative username for splunk machines. Password will be generated."
  default     = "labadmin"
}  

variable "linux-user" {
  type        = string
  description = "The username used to access Linux machines via SSH."
  default     = "labadmin"
}