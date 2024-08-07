# Terraform variables
# See 'variables.tf' for definitions

# Required
resource-group       = "resourcegroupname"
ip-whitelist         = ["1.2.3.4/32", "8.8.8.0/24"]

# Optional (defaults are shown)
timezone             = "W. Europe Standard Time"
domain-name-label    = "indigolabs"
domain-dns-name      = "indigo.labs"
windows-user         = "labadmin"
linux-user           = "labadmin"
hackbox-hostname     = "hackbox"
elastic-hostname     = "elastic"
dc-hostname          = "dc"
winserv2019-hostname = "winserv2019"
win10-hostname       = "win10"
win10-size           = "Standard_B4ms"
winserv2019-size     = "Standard_B4ms"
dc-size              = "Standard_B4ms"
elastic-size         = "Standard_B4ms"
hackbox-size         = "Standard_B4ms"