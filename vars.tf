
############################
#### Scaleway variables ####

variable "scaleway_project_id" {
  description = "Scaleway project ID"
  type        = string
}

variable "scaleway_organization_id" {
  description = "Scaleway organisation ID"
  type        = string
  default     = "9c8b8986-7213-4cbc-b531-fd010fece93e"
}

variable "scaleway_region" {
  description = "Scaleway region ID"
  type        = string
}

variable "scaleway_zone" {
  description = "Scaleway zone ID"
  type        = string
}

############################
##### Module variables #####

# variable "flux_resources_helm_controller_cpu" {
#   description = "CPU resources to set for helm-controller"
#   type        = string
#   default     = "1"
# }

# variable "flux_resources_helm_controller_memory" {
#   description = "Memory resources to set for helm-controller"
#   type        = string
#   default     = "2Gi"
# }

# variable "flux_resources_source_controller_cpu" {
#   description = "CPU resources to set for source-controller"
#   type        = string
#   default     = "1"
# }

# variable "flux_resources_source_controller_memory" {
#   description = "Memory resources to set for source-controller"
#   type        = string
#   default     = "2Gi"
# }

variable "flux_secret_manager_secret_id" {
  description = "ID of the secret in Secret Manager that has the SSH key for Flux (latest version is used)"
  type        = string
}

variable "git_repo" {
  description = "Git repo to use for this cluster's state"
  type        = string
  default     = "kubernetes-state"
}

variable "git_repo_organization" {
  description = "Organization on GitHub that contains the git repo"
  type        = string
  default     = "mastodon-site"
}

variable "git_repo_path" {
  description = "Path for the cluster within the git repo"
  type        = string
}

variable "git_repo_branch" {
  description = "Branch to use from the git repo"
  type        = string
  default     = "main"
}

variable "kubernetes_cluster_name" {
  description = "Name of the Kubernetes cluster to create"
  type        = string
}

variable "kubernetes_node_pools" {
  description = "Node pool(s) to create for this Kubernetes cluster"
  type        = list(map(string))
  default = [{
    pool_id     = 1
    node_type   = "play2_micro"
    zone        = "fr-par-1"
    autoscaling = true
    autohealing = true
    size        = 1
    min_size    = 2
    max_size    = 10
  }]
}

variable "private_network_id" {
  description = "ID of the private network in which to place the Redis cluster"
  type        = string
}