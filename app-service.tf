resource "azurerm_app_service_plan" "default" {
  name                = "${var.name}-plan"
  location            = "${azurerm_resource_group.default.location}"
  resource_group_name = "${azurerm_resource_group.default.name}"
  kind                = "linux"
  reserved            = "true"

  sku {
    tier = "PremiumV2"
    size = "P1v2"
  }
}

resource "azurerm_app_service" "default" {
  name                = "${var.prefix}-${var.name}-${var.environment}"
  location            = "${azurerm_resource_group.default.location}"
  resource_group_name = "${azurerm_resource_group.default.name}"
  app_service_plan_id = "${azurerm_app_service_plan.default.id}"

  site_config = {
    always_on        = true
    linux_fx_version = "DOTNETCORE|2.2"
    app_command_line = "dotnet appservice.dll"
  }

  app_settings {
    "VMURL" = "http://${azurerm_network_interface.vm1.private_ip_address}"
    "WEBSITE_HTTPLOGGING_RETENTION_DAYS" = 7
  }

  lifecycle {
    ignore_changes = [
      "site_config",
    ]
  }
}
