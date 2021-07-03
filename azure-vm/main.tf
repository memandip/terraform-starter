# Create Azure connection and resource group

## The following code defines the Azure Terraform provider:
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {

  }
}

## The following section creates a resource group named `mandipAzureVm` 
## in the `eastus` location
resource "azurerm_resource_group" "myterraformgroup" {
  name     = "mandipAzureVm"
  location = "eastus"
  tags = {
    environment = "Terraform Demo"
  }
}
## In other sections, you reference the resource group with 
## azurerm_resource_group.myterraformgroup.name.

#

# Create virtual network

## The following code creates a virtual network named mandipVNet
##ss in the 10.0.0.0/16 address space:
resource "azurerm_virtual_network" "mandipazurenetwork" {
  name                = "mandipVNet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myterraformgroup.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
}

# The following section creates a subnet named mandipSubnet 
# in the mandipVNet virtual network:
resource "azurerm_subnet" "myterraformsubnet" {
  name                 = "mandipSubnet"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.mandipazurenetwork.name
  address_prefixes     = ["10.0.2.0/24"]
}



# Create public IP address

## To access resources across the Internet, create and assign a public IP address to your VM. 
## The following code creates a public IP address named myPublicIP:

resource "azurerm_public_ip" "myterraformpublicip" {
  name                = "mandipPublicIP"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Dynamic"

  tags = {
    environment = "Terraform Demo"
  }
}



# Create Network Security Group

## Network Security Groups control the flow of network traffic in and out of your VM. 
## The following code creates a network security group named myNetworkSecurityGroup 
## and defines a rule to allow SSH traffic on TCP port 22:
resource "azurerm_network_security_group" "myterraformnsg" {
  name                = "mandipNetworkSecurityGroup"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Terraform Demo"
  }
}



# Create virtual network interface card
## A virtual network interface card (NIC) connects your VM to a given virtual network,
## public IP address, and network security group. The following code in a Terraform 
## template creates a virtual NIC named myNIC connected to the virtual networking 
## resources you've created:
resource "azurerm_network_interface" "myterraformnic" {
  name                = "myNIC"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.myterraformsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id
  }

  tags = {
    environment = "Terraform Demo"
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.myterraformnic.id
  network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}




# Create storage account for diagnostics

## To store boot diagnostics for a VM, you need a storage account. 
## These boot diagnostics can help you troubleshoot problems and monitor the status 
## of your VM.The storage account you create is only to store the boot diagnostics data. 
## As each storage account must have a unique name, the following code generates 
## some random text:
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.myterraformgroup.name
  }

  byte_length = 8
}

## Now you can create a storage account. The following section creates a storage account, 
## with the name based on the random text generated in the preceding step:
resource "azurerm_storage_account" "mystorageaccount" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.myterraformgroup.name
  location                 = "eastus"
  account_replication_type = "LRS"
  account_tier             = "Standard"

  tags = {
    environment = "Terraform Demo"
  }
}



# Create virtual machine

## The final step is to create a VM and use all the resources created. 
## The following code creates a VM named myVM and attaches the virtual NIC named myNIC. 
## The latest Ubuntu 18.04-LTS image is used, and a user named azureuser is created 
## with password authentication disabled.

## The SSH public key file is specified in the admin_ssh_key block. 
## If your SSH public key filename is different or in a different location,
## update the public_key value as needed.

# Create (and display) an SSH key
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

output "tls_private_key" {
  value     = tls_private_key.example_ssh.private_key_pem
  sensitive = true
}

resource "azurerm_linux_virtual_machine" "myterraformvm" {
  name                  = "myVM"
  location              = "eastus"
  resource_group_name   = azurerm_resource_group.myterraformgroup.name
  network_interface_ids = [azurerm_network_interface.myterraformnic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "myvm"
  admin_username                  = "mandip"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "mandip"
    # local ssh pulic key path
    public_key = file("~/.ssh/id_rsa.pub")
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }

  tags = {
    environment = "Terraform Demo"
  }

}
