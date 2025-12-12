output "resource_group_name" {
  description = "resource group name"
  value       = data.azurerm_resource_group.current_rg.name
}

output "web_app_name" {
  description = "Web app name"
  value       = azurerm_linux_web_app.app.name
}

output "web_app_url" {
  description = "Web app URL"
  value       = "https://${azurerm_linux_web_app.app.default_hostname}"
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "acr_admin_username" {
  value     = azurerm_container_registry.acr.admin_username
  sensitive = true
}