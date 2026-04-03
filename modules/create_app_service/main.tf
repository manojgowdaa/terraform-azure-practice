resource "azurerm_service_plan" "app_plan" {
  name                = var.app_service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "B1"

  tags = {
    Name = var.app_service_plan_name
  }
}

resource "azurerm_linux_web_app" "app" {
  count               = var.app_count
  name                = "${var.app_name_prefix}-${count.index + 1}"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.app_plan.id

  site_config {
    application_stack {
      docker_image_name   = var.docker_image
      docker_registry_url = var.docker_registry_url
    }
  }

  tags = {
    Name = "${var.app_name_prefix}-${count.index + 1}"
  }
}
