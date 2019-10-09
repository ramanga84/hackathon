variable "prefix" {
  description = "The prefix used for all resources in this example"
  default     = "xl"
}

variable "location" {
  description = "The Azure location where all resources in this example should be created"
}

#variable "subscription_id" {
#  description = "Azure Subscription ID to be used for billing"
#}

variable "p_sql_master_password" {
  description = "PostgreSql master password"
}

