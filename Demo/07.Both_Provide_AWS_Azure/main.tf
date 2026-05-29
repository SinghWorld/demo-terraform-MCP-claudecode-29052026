# Key things to note:

# `terraform init` will download both the AWS and AzureRM providers automatically from the same directory.
# Azure requires more supporting resources (VNet → Subnet → NIC) before you can create a VM — AWS is simpler for a basic EC2.
# The data "aws_ami" block dynamically fetches the latest Amazon Linux 2 AMI so you don't hardcode region-specific AMI IDs.
# For the Azure SSH key, make sure `~/.ssh/id_rsa.pub` exists on your machine, or replace with an inline key string.
# Both resources are tagged with Environment = dev for easy identification.
# `terraform init` -upgrade
# `ssh-keygen` -t rsa -b 4096
# `az login` --use-device-code


# ============================================================
# TERRAFORM - Multi-Cloud: AWS EC2 + Azure VM (Basic Example)
# ============================================================

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# ─────────────────────────────────────────
# PROVIDERS
# ─────────────────────────────────────────

provider "aws" {
  region = "us-east-1" # Sydney — change as needed
}

provider "azurerm" {
  features {}
}

# ─────────────────────────────────────────
# AWS — EC2 INSTANCE
# ─────────────────────────────────────────

# Fetch latest Amazon Linux 2 AMI dynamically
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro" # Free Tier eligible

  tags = {
    Name        = "my-ec2-instance"
    Environment = "dev"
  }
}

# ─────────────────────────────────────────
# AZURE — LINUX VIRTUAL MACHINE
# ─────────────────────────────────────────

resource "azurerm_resource_group" "rg" {
  name     = "my-rg"
  location = "australiaeast" # Change as needed
}

resource "azurerm_virtual_network" "vnet" {
  name                = "my-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "my-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "my-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "my-azure-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s" # Low-cost size
  admin_username      = "adminuser"

  # Use SSH key (recommended) or set disable_password_authentication = false
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub") # Ensure this exists locally
  }

  network_interface_ids = [azurerm_network_interface.nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = {
    Environment = "dev"
  }
}

# ─────────────────────────────────────────
# OUTPUTS
# ─────────────────────────────────────────

output "aws_ec2_instance_id" {
  value = aws_instance.web.id
}

output "aws_ec2_public_ip" {
  value = aws_instance.web.public_ip
}

output "azure_vm_name" {
  value = azurerm_linux_virtual_machine.vm.name
}

output "azure_vm_private_ip" {
  value = azurerm_network_interface.nic.private_ip_address
}