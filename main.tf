resource "azurerm_resource_group" "default" {
  name     = "${var.name}-${var.environment}-rg"
  location = "West US"
}

resource "azurerm_resource_group" "windows" {
  name     = "${var.name}-windows-${var.environment}-rg"
  location = "West US"
}
