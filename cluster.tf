resource "scaleway_k8s_cluster" "cluster" {
  name                        = var.kubernetes_cluster_name
  type                        = "kapsule"
  version                     = "1.28"
  cni                         = "cilium"
  delete_additional_resources = true
  private_network_id          = var.private_network_id

  autoscaler_config {
    disable_scale_down              = false
    scale_down_delay_after_add      = "2m"
    scale_down_unneeded_time        = "2m"
    estimator                       = "binpacking"
    expander                        = "random"
    ignore_daemonsets_utilization   = true
    balance_similar_node_groups     = true
    expendable_pods_priority_cutoff = -5
    max_graceful_termination_sec    = 600
  }

  auto_upgrade {
    enable                        = true
    maintenance_window_day        = "any"
    maintenance_window_start_hour = 4
  }
}

resource "scaleway_k8s_pool" "pools" {
  for_each    = { for config in var.kubernetes_node_pools : config.node_type => config }
  cluster_id  = scaleway_k8s_cluster.cluster.id
  name        = each.value.node_type
  node_type   = each.value.node_type
  autoscaling = each.value.autoscaling
  autohealing = each.value.autohealing
  size        = each.value.size
  min_size    = each.value.min_size
  max_size    = each.value.max_size
}