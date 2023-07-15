resource "flux_bootstrap_git" "kubernetes_state" {
  path           = "./${var.git_repo_path}/flux-bootstrap"
  interval       = "30s"
  network_policy = false
  #   kustomization_override = templatefile("flux-kustomization.yaml", {
  #     flux_resources_helm_controller_memory   = var.flux_resources_helm_controller_memory,
  #     flux_resources_helm_controller_cpu      = var.flux_resources_helm_controller_cpu,
  #     flux_resources_source_controller_memory = var.flux_resources_source_controller_memory,
  #     flux_resources_source_controller_cpu    = var.flux_resources_source_controller_cpu,
  #   })
  depends_on = [scaleway_k8s_pool.pool]
}