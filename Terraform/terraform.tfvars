# Terraform variables
# See 'variables.tf' for definitions

# Required
resource-group       = "cs-soc-playground"
ip-whitelist         = ["1.2.3.4/32", "8.8.8.0/24"]

# Optional (defaults are shown)
timezone             = "W. Europe Standard Time"
domain-name-label    = "indigolabs"
domain-dns-name      = "indigo.labs"
windows-user         = "labadmin"
linux-user           = "labadmin"
hackbox-hostname     = "hackbox"
splunk-hostname     = "splunk"
syslog-hostname     = "syslog"
linux-hostname     = "linuxlab"
dc-hostname          = "dc"
win10def-hostname       = "win10def"
win10xdr-hostname       = "win10xdr"
win10xdr-size           = "Standard_B2ms"
win10def-size           = "Standard_B2ms"
dc-size              = "Standard_B4ms"
splunk-size         = "Standard_B2ms"
hackbox-size         = "Standard_B2ms"
linux-size			= "Standard_B2s"
syslog-size			= "Standard_B2s"