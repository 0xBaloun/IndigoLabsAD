# Get the current public IP for deployment whitelisting
data "http" "public-ip" {
  url = "http://ipv4.icanhazip.com"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "indigolabs-vnet" {
  name                = "indigolabs-vnet"
  resource_group_name = data.azurerm_resource_group.cs-soc-playground.name
  location            = data.azurerm_resource_group.cs-soc-playground.location
  address_space       = ["10.0.0.0/8"]
}

# Create a subnet within the virtual network
resource "azurerm_subnet" "indigolabs-subnet" {
  name                 = "indigolabs-subnet"
  resource_group_name  = data.azurerm_resource_group.cs-soc-playground.name
  virtual_network_name = azurerm_virtual_network.indigolabs-vnet.name
  address_prefixes     = ["10.13.37.0/24"]
}

# Create a network security group for the subnet
resource "azurerm_network_security_group" "indigolabs-nsg" {
  name                = "indigolabs-nsg"
  location            = data.azurerm_resource_group.cs-soc-playground.location
  resource_group_name = data.azurerm_resource_group.cs-soc-playground.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes    = "${concat(var.ip-whitelist, ["${chomp(data.http.public-ip.response_body)}/32"])}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefixes    = var.ip-whitelist
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "RDP"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefixes    = var.ip-whitelist
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Internal"
    priority                   = 1004
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.13.37.0/24"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "indigolabs-nsga" {
  subnet_id                 = azurerm_subnet.indigolabs-subnet.id
  network_security_group_id = azurerm_network_security_group.indigolabs-nsg.id
}

# Create a public IP address for the lab
resource "azurerm_public_ip" "indigolabs-ip" {
  name                = "indigolabs-ip"
  location            = data.azurerm_resource_group.cs-soc-playground.location
  resource_group_name = data.azurerm_resource_group.cs-soc-playground.name
  allocation_method   = "Static"
  domain_name_label   = var.domain-name-label
  sku                 = "Standard"
}

# Create another public IP address for outbound traffic
resource "azurerm_public_ip" "indigolabs-ip-outbound" {
  name                = "indigolabs-ip-outbound"
  location            = data.azurerm_resource_group.cs-soc-playground.location
  resource_group_name = data.azurerm_resource_group.cs-soc-playground.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Create a load balancer on the public IP
resource "azurerm_lb" "indigolabs-lb" {
  name                = "indigolabs-lb"
  location            = data.azurerm_resource_group.cs-soc-playground.location
  resource_group_name = data.azurerm_resource_group.cs-soc-playground.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "indigolabs-lb-ip-public"
    public_ip_address_id = azurerm_public_ip.indigolabs-ip.id
  }
}

resource "azurerm_lb_nat_rule" "indigolabs-lb-nat-http" {
  resource_group_name            = data.azurerm_resource_group.cs-soc-playground.name
  loadbalancer_id                = azurerm_lb.indigolabs-lb.id
  name                           = "HTTPAccess"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "indigolabs-lb-ip-public"
}

resource "azurerm_lb_nat_rule" "indigolabs-lb-nat-ssh" {
  resource_group_name            = data.azurerm_resource_group.cs-soc-playground.name
  loadbalancer_id                = azurerm_lb.indigolabs-lb.id
  name                           = "SSHAccess"
  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = "indigolabs-lb-ip-public"
}

resource "azurerm_lb_nat_rule" "indigolabs-lb-nat-rdp" {
  resource_group_name            = data.azurerm_resource_group.cs-soc-playground.name
  loadbalancer_id                = azurerm_lb.indigolabs-lb.id
  name                           = "RDPAccess"
  protocol                       = "Tcp"
  frontend_port                  = 3389
  backend_port                   = 3389
  frontend_ip_configuration_name = "indigolabs-lb-ip-public"
}

# Create NAT gateway for outbound internet access
resource "azurerm_nat_gateway" "indigolabs-nat-gateway" {
  name                    = "indigolabs-nat-gateway"
  location                = data.azurerm_resource_group.cs-soc-playground.location
  resource_group_name     = data.azurerm_resource_group.cs-soc-playground.name
}

resource "azurerm_nat_gateway_public_ip_association" "indigolabs-nat-gateway-ip" {
  nat_gateway_id       = azurerm_nat_gateway.indigolabs-nat-gateway.id
  public_ip_address_id = azurerm_public_ip.indigolabs-ip-outbound.id
}

resource "azurerm_subnet_nat_gateway_association" "indigolabs-nat-gateway-subnet" {
  subnet_id      = azurerm_subnet.indigolabs-subnet.id
  nat_gateway_id = azurerm_nat_gateway.indigolabs-nat-gateway.id
}