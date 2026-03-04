output "lb_ip_address" {
  description = "Public IPv4 address of the ingress load balancer"
  value       = var.create_lb ? scaleway_lb_ip.ingress[0].ip_address : null
}

output "lb_id" {
  description = "ID of the ingress load balancer"
  value       = var.create_lb ? scaleway_lb.ingress[0].id : null
}
