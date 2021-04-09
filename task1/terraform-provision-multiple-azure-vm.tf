# Configure the Microsoft Azure Provider
provider "azurerm" {
    version = "~>2.0"
    features {}
}

resource "azurerm_resource_group" "azure_rg" {
 name     = "acctestrg"
 location = "eastus"
}

resource "azurerm_virtual_network" "vnet" {
 name                = "acctvn"
 address_space       = ["10.0.0.0/16"]
 location            = azurerm_resource_group.azure_rg.location
 resource_group_name = azurerm_resource_group.azure_rg.name
}

resource "azurerm_subnet" "vmsubnet" {
 name                 = "acctsub"
 resource_group_name  = azurerm_resource_group.azure_rg.name
 virtual_network_name = azurerm_virtual_network.vnet.name
 address_prefix       = "10.0.2.0/24"
}

resource "azurerm_public_ip" "vmip" {
 count                        = 2
 name                         = "vm-ip-${count.index}"
 #name                         = "publicIPForLB"
 location                     = azurerm_resource_group.azure_rg.location
 resource_group_name          = azurerm_resource_group.azure_rg.name
 allocation_method            = "Dynamic"
}

# NIC with Public IP Address
resource "azurerm_network_interface" "vmnic" {
 count               = 2
 name                = "acctni${count.index}"
 location            = azurerm_resource_group.azure_rg.location
 resource_group_name = azurerm_resource_group.azure_rg.name

 ip_configuration {
   name                          = "testConfiguration"
   subnet_id                     = azurerm_subnet.vmsubnet.id
   private_ip_address_allocation = "dynamic"
   public_ip_address_id          = element(azurerm_public_ip.vmip.*.id, count.index)
 }
}

resource "azurerm_managed_disk" "azure_md" {
 count                = 2
 name                 = "datadisk_existing_${count.index}"
 location             = azurerm_resource_group.azure_rg.location
 resource_group_name  = azurerm_resource_group.azure_rg.name
 storage_account_type = "Standard_LRS"
 create_option        = "Empty"
 disk_size_gb         = "1023"
}

resource "azurerm_availability_set" "avset" {
 name                         = "avset"
 location                     = azurerm_resource_group.azure_rg.location
 resource_group_name          = azurerm_resource_group.azure_rg.name
 platform_fault_domain_count  = 2
 platform_update_domain_count = 2
 managed                      = true
}

variable "external_ip" {
    type        = list(string)
   default      = ["your public ip to allow traffic to server"]
}

# Add a Network security group
resource "azurerm_network_security_group" "nsgname" {
    name                   = "vm-nsg"
    location               = azurerm_resource_group.azure_rg.location
    resource_group_name    = azurerm_resource_group.azure_rg.name

    security_rule {
        name                       = "PORT_SSH"
        priority                   = 101
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefixes    = var.external_ip
        destination_address_prefix = "*"
  }
}



#Associate NSG with  subnet
resource "azurerm_subnet_network_security_group_association" "nsgsubnet" {
    subnet_id                    = azurerm_subnet.vmsubnet.id
    network_security_group_id    = azurerm_network_security_group.nsgname.id
}

resource "azurerm_virtual_machine" "terravm" {
 count                 = 2
 name                  = "acctvm${count.index}"
 location              = azurerm_resource_group.azure_rg.location
 availability_set_id   = azurerm_availability_set.avset.id
 resource_group_name   = azurerm_resource_group.azure_rg.name
 network_interface_ids = [element(azurerm_network_interface.vmnic.*.id, count.index)]
 vm_size               = "Standard_DS1_v2"

 # Uncomment this line to delete the OS disk automatically when deleting the VM
 # delete_os_disk_on_termination = true

 # Uncomment this line to delete the data disks automatically when deleting the VM
 # delete_data_disks_on_termination = true

 storage_image_reference {
   publisher = "Canonical"
   offer     = "UbuntuServer"
   sku       = "16.04-LTS"
   version   = "latest"
 }

 storage_os_disk {
   name              = "myosdisk${count.index}"
   caching           = "ReadWrite"
   create_option     = "FromImage"
   managed_disk_type = "Standard_LRS"
 }

 # Optional data disks
 storage_data_disk {
   name              = "datadisk_new_${count.index}"
   managed_disk_type = "Standard_LRS"
   create_option     = "Empty"
   lun               = 0
   disk_size_gb      = "1023"
 }

 storage_data_disk {
   name            = element(azurerm_managed_disk.azure_md.*.name, count.index)
   managed_disk_id = element(azurerm_managed_disk.azure_md.*.id, count.index)
   create_option   = "Attach"
   lun             = 1
   disk_size_gb    = element(azurerm_managed_disk.azure_md.*.disk_size_gb, count.index)
 }

 os_profile {
   computer_name  = "hostname"
   admin_username = "testadmin"
   admin_password = "Password1234!"
 }

 os_profile_linux_config {
   disable_password_authentication = false
 }

 tags = {
   environment = "staging"
 }
}

