terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.27.0"
    }
  }
}

provider "kubernetes" {
 config_path = "/root/aks_exercise/config"
}

resource "kubernetes_deployment" "example" {
  metadata {
    name = "apache-aks"
    labels = {
     app="apache-app"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "apache-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "apache-app"
        }
      }

      spec {
        container {
          image = "smehta26/apache:alpine"
          name  = "apache-image"
            }
          }
        }
      }
    }



resource "kubernetes_service" "example" {
  metadata {
    name = "apache-service"
  }
  spec {
    selector = {
      app = "apache-app"
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}





