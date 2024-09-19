resource "kubernetes_deployment" "app" {
  metadata {
    name      = var.project_name
    namespace = var.k8s_namespace
    labels = {
      App = var.project_name
    }
  }

  spec {
    replicas = var.k8s_replica_count

    selector {
      match_labels = {
        App = var.project_name
      }
    }

    template {
      metadata {
        labels = {
          App = var.project_name
        }
      }
      spec {
        container {
          name  = var.project_name
          image = "nginx"
          port {
            container_port = var.k8s_app_port
          }
          resources {
            requests = {
              cpu    = var.k8s_cpu
              memory = var.k8s_memory
            }

            limits = {
              cpu    = var.k8s_cpu_limit
              memory = var.k8s_memory_limit
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app_service" {
  metadata {
    name      = var.project_name
    namespace = var.k8s_namespace
  }

  spec {
    selector = {
      App = var.project_name
    }
    port {
      port        = var.k8s_app_port
      target_port = var.k8s_app_port
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_ingress" "app_ingress" {
  metadata {
    name      = "${var.project_name}-ingress"
    namespace = var.k8s_namespace
    annotations = {
      "kubernetes.io/ingress.class" = "alb"
      "alb.ingress.kubernetes.io/scheme" = "internet-facing"
    }
  }
  spec {
    rule {
      http {
        path {
          path     = "/*"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.app_service.metadata[0].name
              port {
                number = var.k8s_app_port
              }
            }
          }
        }
      }
    }
  }
}