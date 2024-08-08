output "region" {
  value = data.azurerm_resource_group.cs-soc-playground.location
  description = "The region in which the resources are deployed. Based on the configured resource group."
}

output "public-ip" {
  value = azurerm_public_ip.indigolabs-ip.ip_address
  description = "The public IP address used to connect to the lab."
}

output "public-ip-dns" {
  value = azurerm_public_ip.indigolabs-ip.fqdn
  description = "The public DNS name used to connect to the lab."
}

output "public-ip-outbound" {
    value = azurerm_public_ip.indigolabs-ip-outbound.ip_address
    description = "The public IP address used by the lab machines to reach the internet."
}

output "ip-whitelist" {
    value = join(", ", var.ip-whitelist)
    description = "The IP address(es) that are allowed to connect to the various lab interfaces."
}

output "splunk-url" {
    value = "http://10.13.37.50:8000"
    description = "The URL used to connect to the splunk security dashboard."
}

output "splunk-user" {
    value = "splunk"
    description = "The username to connect to splunk."
}

output "splunk-password" {
    value = random_string.linuxpass.result
    description = "The password to connect to splunk."
}

output "linux-user" {
    value = var.linux-user
    description = "The SSH username used to connect to Linux machines."
}

output "linux-password" {
    value = random_string.linuxpass.result
    description = "The password used for Linux admin accounts."
}

output  "windows-domain" {
    value = var.domain-dns-name
    description = "The the Active Directory domain name."
}

output "windows-user" {
    value = var.windows-user
    description = "The username used to connect to the Windows machine."
}

output "windows-password" {
    value = random_string.windowspass.result
    description = "The password used for Windows local admin accounts."
}

output "hackbox-hostname" {
    value = var.hackbox-hostname
    description = "The hostname of the attacker VM."
}

output "splunk-hostname" {
    value = var.splunk-hostname
    description = "The hostname of the splunk VM."
}

output "syslog-hostname" {
    value = var.syslog-hostname
    description = "The hostname of the syslog VM."
}

output "linux-hostname" {
    value = var.syslog-hostname
    description = "The hostname of the linux VM."
}

output "dc-hostname" {
    value = var.dc-hostname
    description = "The hostname of the Domain Controller."
}

output "win10xdr-hostname"{
    value = var.win10-hostname
    description = "The hostname of the Windows 10 VM."
}

output "win10def-hostname"{
    value = var.win10-hostname
    description = "The hostname of the Windows 10 VM."
}