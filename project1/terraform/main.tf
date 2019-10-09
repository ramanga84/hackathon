provider "azurerm" {
  version         = "=1.24.0"
#  subscription_id = "${var.subscription_id}"
}

resource "azurerm_resource_group" "hack1" {
  name     = "${var.prefix}-resources"
  location = "${var.location}"
}

resource "azurerm_postgresql_server" "hack1" {
  name                = "${var.prefix}-psql-server"
  location            = "${azurerm_resource_group.hack1.location}"
  resource_group_name = "${azurerm_resource_group.hack1.name}"

  sku {
    name     = "B_Gen5_2"
    capacity = 2
    tier     = "Basic"
    family   = "Gen5"
  }

  storage_profile {
    storage_mb            = 5120
    backup_retention_days = 7
    geo_redundant_backup  = "Disabled"
#    auto_grow             = "Enabled"
  }

  administrator_login          = "psqladmin"
  administrator_login_password = "${var.p_sql_master_password}"
  version                      = "9.5"
  ssl_enforcement              = "Disabled"
}

# This is the database that our application will use
resource "azurerm_postgresql_database" "hack1" {
  name                = "${var.prefix}_postsql_db"
  resource_group_name = "${azurerm_resource_group.hack1.name}"
  server_name         = "${azurerm_postgresql_server.hack1.name}"
  charset             = "utf8"
  collation           = "English_United States.1252"
}

# This rule is to enable the 'Allow access to Azure services' checkbox
resource "azurerm_postgresql_firewall_rule" "hack1" {
  name                = "${var.prefix}-psql-firewall"
  resource_group_name = "${azurerm_resource_group.hack1.name}"
  server_name         = "${azurerm_postgresql_server.hack1.name}"
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_app_service_plan" "hack1" {
  name                = "${var.prefix}-asp"
  location            = "${azurerm_resource_group.hack1.location}"
  resource_group_name = "${azurerm_resource_group.hack1.name}"
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Free"
    size = "F1"
  }
}

# This creates the service definition
resource "azurerm_app_service" "hack1" {
  name                = "${var.prefix}-appservice"
  location            = "${azurerm_resource_group.hack1.location}"
  resource_group_name = "${azurerm_resource_group.hack1.name}"
  app_service_plan_id = "${azurerm_app_service_plan.hack1.id}"

  site_config {
     python_version   = "3.4"
     scm_type         = "LocalGit"
     always_on        = true
  }
}
