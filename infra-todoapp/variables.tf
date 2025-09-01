variable "client_id" {
  description = "Azure Service Principal AppId"
}

variable "client_secret" {
  description = "Azure Service Principal Password"
  sensitive   = true
}

variable "subscription_id" {
  description = "Azure Subscription ID"
}

variable "tenant_id" {
  description = "Azure Tenant ID"
}
