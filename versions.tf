terraform {
  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = "1.2.3"
    }
    github = {
      source  = "integrations/github"
      version = ">= 4.5.2"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.4.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.13.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.2"
    }
    scaleway = {
      source  = "scaleway/scaleway"
      version = ">= 2.24"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.1.0"
    }
  }
  required_version = ">= 1.4"
}