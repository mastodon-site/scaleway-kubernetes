resource "scaleway_lb_ip" "ingress" {
  count = var.create_lb ? 1 : 0
}

resource "scaleway_lb" "ingress" {
  count  = var.create_lb ? 1 : 0
  ip_ids = [scaleway_lb_ip.ingress[0].id]
  name   = "${var.kubernetes_cluster_name}-ingress"
  type   = var.lb_type

  private_network {
    private_network_id = var.private_network_id
  }
}
