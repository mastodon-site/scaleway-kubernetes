resource "scaleway_iam_application" "external_secrets" {
  name = "external-secrets on ${var.kubernetes_cluster_name} Kubernetes cluster"
}

resource "scaleway_iam_api_key" "external_secrets" {
  application_id = scaleway_iam_application.external_secrets.id
  description    = "API key for external-secrets on ${var.kubernetes_cluster_name} Kubernetes cluster"
}

resource "kubernetes_secret" "scaleway_secret_manager_credentials" {
  metadata {
    name      = "scaleway-secret-manager-credentials"
    namespace = kubernetes_namespace.platform.metadata[0].name
  }

  data = {
    access-key        = scaleway_iam_api_key.external_secrets.access_key
    secret-access-key = scaleway_iam_api_key.external_secrets.secret_key
  }

  depends_on = [kubernetes_namespace.platform]
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

resource "kubernetes_manifest" "secret_manager_store" {
  manifest = {
    "apiVersion" = "external-secrets.io/v1beta1"
    "kind"       = "SecretStore"
    "metadata" = {
      "name"      = "secret-manager"
      "namespace" = kubernetes_namespace.platform.metadata[0].name
    }
    "spec" = {
      "provider" = {
        "scaleway" = {
          "region"    = var.scaleway_region
          "projectId" = var.scaleway_project_id

          "accessKey" = {
            "secretRef" = {
              "name" = "scaleway-secret-manager-credentials"
              "key"  = "access-key"
            }
          }

          "secretKey" = {
            "secretRef" = {
              "name" = "scaleway-secret-manager-credentials"
              "key"  = "secret-access-key"
            }
          }
        }
      }
    }
  }
  depends_on = [kubernetes_namespace.platform, kubernetes_secret.scaleway_secret_manager_credentials]
}