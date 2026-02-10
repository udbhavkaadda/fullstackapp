output "bepool_id" {
  description = "ID of the Load Balancer Backend Address Pool"
  value       = azurerm_lb_backend_address_pool.bepool.id
}
