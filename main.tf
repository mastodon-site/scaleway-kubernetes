provider "kubectl" {
  host  = scaleway_k8s_cluster.cluster.kubeconfig[0].host
  token = scaleway_k8s_cluster.cluster.kubeconfig[0].token
  cluster_ca_certificate = base64decode(
    scaleway_k8s_cluster.cluster.kubeconfig[0].cluster_ca_certificate,
  )
  apply_retry_count = 15
}

data "scaleway_secret_version" "flux_ssh_key" {
  secret_id = var.flux_secret_manager_secret_id
  revision  = "latest"
}

provider "flux" {
  kubernetes = {
    host  = scaleway_k8s_cluster.cluster.kubeconfig[0].host
    token = scaleway_k8s_cluster.cluster.kubeconfig[0].token
    cluster_ca_certificate = base64decode(
      scaleway_k8s_cluster.cluster.kubeconfig[0].cluster_ca_certificate,
    )
  }

  git = {
    url    = "ssh://git@github.com/${var.git_repo_organization}/${var.git_repo}.git"
    branch = var.git_repo_branch
    ssh = {
      username    = "git"
      private_key = base64decode(data.scaleway_secret_version.flux_ssh_key.data)
    }
  }
}