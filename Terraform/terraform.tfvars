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
dc-hostname          = "dc"
win10-hostname       = "win10"
win10-size           = "Standard_B2ms"
dc-size              = "Standard_B4ms"
splunk-size         = "Standard_B2ms"
hackbox-size         = "Standard_B2ms"