output "app_service_name" {
  value = "${azurerm_app_service.hack1.name}"
}

output "app_service_default_hostname" {
  value = "https://${azurerm_app_service.hack1.default_site_hostname}"
}
