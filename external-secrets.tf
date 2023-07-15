resource "scaleway_iam_application" "external_secrets" {
  name = "external-secrets on ${var.kubernetes_cluster_name} Kubernetes cluster"
}

resource "scaleway_iam_api_key" "external_secrets" {
  application_id = scaleway_iam_application.external_secrets.id
  description    = "API key for external-secrets on ${var.kubernetes_cluster_name} Kubernetes cluster"
}

resource "scaleway_iam_policy" "external_secrets" {
  name           = "External-secrets (${var.kubernetes_cluster_name})"
  description    = "Grant external-secrets on the ${var.kubernetes_cluster_name} Kubernetes cluster access to Secret Manager"
  application_id = scaleway_iam_application.external_secrets.id
  rule {
    project_ids          = [var.scaleway_project_id]
    permission_set_names = ["SecretManagerFullAccess"]
  }
}

resource "kubernetes_secret" "scaleway_secret_manager_credentials" {
  metadata {
    name      = "scaleway-secret-manager-credentials"
    namespace = "kube-system"
  }

  data = {
    access-key        = scaleway_iam_api_key.external_secrets.access_key
    secret-access-key = scaleway_iam_api_key.external_secrets.secret_key
  }
}

resource "kubernetes_manifest" "secret_manager_store" {
  manifest = {
    "apiVersion" = "external-secrets.io/v1beta1"
    "kind"       = "ClusterSecretStore"
    "metadata" = {
      "name" = "secret-manager"
    }
    "spec" = {
      "provider" = {
        "scaleway" = {
          "region"    = var.scaleway_region
          "projectId" = var.scaleway_project_id

          "accessKey" = {
            "secretRef" = {
              "name"      = "scaleway-secret-manager-credentials"
              "namespace" = "kube-system"
              "key"       = "access-key"
            }
          }

          "secretKey" = {
            "secretRef" = {
              "name"      = "scaleway-secret-manager-credentials"
              "namespace" = "kube-system"
              "key"       = "secret-access-key"
            }
          }
        }
      }
    }
  }
  depends_on = [kubernetes_secret.scaleway_secret_manager_credentials]
}