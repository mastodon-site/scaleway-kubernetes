resource "scaleway_lb_ip" "v4" {
  for_each = toset(var.load_balancer_zones)
  zone     = each.key
  reverse  = "mastodon.site"
}

resource "scaleway_lb_ip" "v6" {
  for_each = toset(var.load_balancer_zones)
  zone     = each.key
  is_ipv6  = true
  reverse  = "mastodon.site"
}

resource "scaleway_lb" "main" {
  ip_ids = local.v6_ip_ids
  zone = "fr-par-1"
  type   = "LB-S"
  private_network {
    private_network_id = var.private_network_id
  }
}

locals {
  v4_ip_ids  = [for ip in scaleway_lb_ip.v4 : ip.id]
  v6_ip_ids  = [for ip in scaleway_lb_ip.v6 : ip.id]
  all_ip_ids = concat(local.v4_ip_ids, local.v6_ip_ids)
  v4_ips  = [for ip in scaleway_lb_ip.v4 : ip.ip_address]
  v6_ips  = [for ip in scaleway_lb_ip.v6 : ip.ip_address]
  all_ips = concat(local.v4_ips, local.v6_ips)
}