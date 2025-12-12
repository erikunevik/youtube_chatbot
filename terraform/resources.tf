# Resource group
data "azurerm_resource_group" "current_rg" {
  name = "eriksaichatbot" # Add your own taken RG name from the created function app
}

# Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = "${var.prefix_app_name}${random_string.suffix.result}acr" 
  location            = var.location
  resource_group_name = data.azurerm_resource_group.current_rg.name
  sku                 = "Basic"
  admin_enabled       = true
  tags                = local.common_tags
}

# App Service Plan
resource "azurerm_service_plan" "asp" {
  name                = "${var.prefix_app_name}-${random_string.suffix.result}-asp"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.current_rg.name
  sku_name            = "S1"
  os_type             = "Linux"
  tags                = local.common_tags
}

# Web App 
resource "azurerm_linux_web_app" "app" {
  name                = "${var.prefix_app_name}-${random_string.suffix.result}-app"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.current_rg.name
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    always_on = true

    application_stack {
      docker_image_name   = "${azurerm_container_registry.acr.login_server}/${var.docker_image_name}"
      docker_registry_url = "https://${azurerm_container_registry.acr.login_server}"
    }
  }

  app_settings = {
    "WEBSITES_PORT"    = var.websites_port
    "OPENAI_API_KEY"   = var.openai_api_key
    "FUNCTION_APP_API" = var.function_app_api
    "SUBSCRIPTION_ID"  = var.subscription_id

  }

  tags = local.common_tags
}


