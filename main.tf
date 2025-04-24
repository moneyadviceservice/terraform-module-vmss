resource "tls_private_key" "vmss" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

data "azurerm_shared_image" "devops-ubuntu" {
  count               = var.vmss_source_image_id == null ? 1 : 0
  name                = "devops-ubuntu"
  gallery_name        = "hmcts"
  resource_group_name = "hmcts-image-gallery-rg"
  provider            = azurerm.image_gallery
}

resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  count = lower(var.vm_type) == "linux-scale-set" ? 1 : 0

  name                = var.vmss_name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku       = var.vmss_sku
  instances = var.vmss_instance_count

  admin_username = var.vmss_admin_username
  admin_password = var.vm_admin_password
  zones          = var.vm_availabilty_zones
  custom_data    = var.custom_data

  tags = var.tags

  source_image_reference {
    publisher = var.vm_publisher_name
    offer     = var.vm_offer
    sku       = var.vm_image_sku
    version   = var.vm_version
  }
  overprovision          = false
  single_placement_group = false

  admin_ssh_key {
    username   = var.vmss_admin_username
    public_key = tls_private_key.vmss.public_key_openssh
  }

  os_disk {
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "${var.vmss_name}-nic"
    primary = true

    ip_configuration {
      name      = "IpConfig"
      primary   = true
      subnet_id = azurerm_subnet.subnet.id
    }
  }

  dynamic "automatic_os_upgrade_policy" {
    for_each = try(var.automatic_os_upgrade_policy, {})
    content {
      disable_automatic_rollback  = automatic_os_upgrade_policy.value.disable_automatic_rollback
      enable_automatic_os_upgrade = automatic_os_upgrade_policy.value.enable_automatic_os_upgrade
    }
  }
}