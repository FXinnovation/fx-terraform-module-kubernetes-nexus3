#####
# Locals
#####

locals {
  port         = 8081
  service_port = 80
  labels = {
    "version"    = var.image_version
    "part-of"    = "shared-services"
    "managed-by" = "terraform"
    "name"       = "nexus3"
  }
  annotations = {}
}

#####
# Randoms
#####

resource "random_string" "selector" {
  count = var.enabled ? 1 : 0

  special = false
  upper   = false
  number  = false
  length  = 8
}

#####
# Statefulset
#####

resource "kubernetes_stateful_set" "this" {
  count = var.enabled ? 1 : 0

  metadata {
    name      = var.stateful_set_name
    namespace = var.namespace
    annotations = merge(
      {},
      local.annotations,
      var.annotations,
      var.stateful_set_annotations
    )
    labels = merge(
      {
        instance  = var.stateful_set_name
        component = "application"
      },
      local.labels,
      var.labels,
      var.stateful_set_labels
    )
  }

  spec {
    replicas     = 1
    service_name = element(concat(kubernetes_service.this.*.metadata.0.name, list("")), 0)

    update_strategy {
      type = "RollingUpdate"
    }

    selector {
      match_labels = {
        selector = "nexus3-${element(concat(random_string.selector.*.result, list("")), 0)}"
      }
    }

    template {
      metadata {
        annotations = merge(
          local.annotations,
          var.annotations,
          var.stateful_set_template_annotations
        )
        labels = merge(
          {
            instance  = var.stateful_set_name
            component = "application"
            selector  = "nexus3-${element(concat(random_string.selector.*.result, list("")), 0)}"
          },
          local.labels,
          var.labels,
          var.stateful_set_template_labels
        )
      }

      spec {
        dynamic "init_container" {
          for_each = var.stateful_set_volume_claim_template_enabled ? [1] : []

          content {
            name              = "init-chown-data"
            image             = "busybox:latest"
            image_pull_policy = "IfNotPresent"
            command           = ["chown", "-R", "200:200", "/data"]

            volume_mount {
              name       = var.stateful_set_volume_claim_template_name
              mount_path = "/data"
              sub_path   = ""
            }
          }
        }

        container {
          name              = "nexus3"
          image             = "${var.image}:${var.image_version}"
          image_pull_policy = "IfNotPresent"

          resources {
            requests {
              cpu    = var.resources_requests_cpu
              memory = var.resources_requests_memory
            }
            limits {
              cpu    = var.resources_limits_cpu
              memory = var.resources_limits_memory
            }
          }

          port {
            container_port = local.port
            protocol       = "TCP"
            name           = "http"
          }

          dynamic "port" {
            for_each = var.additional_ports

            content {
              container_port = port.value.port
              protocol       = port.value.protocol
              name           = port.value.name
            }
          }

          readiness_probe {
            http_get {
              path   = "/"
              port   = local.port
              scheme = "HTTP"
            }

            initial_delay_seconds = 60
            timeout_seconds       = 5
            failure_threshold     = 5
            success_threshold     = 1
            period_seconds        = 10
          }

          liveness_probe {
            http_get {
              path   = "/"
              port   = local.port
              scheme = "HTTP"
            }

            initial_delay_seconds = 120
            timeout_seconds       = 5
            failure_threshold     = 5
            success_threshold     = 1
            period_seconds        = 10
          }

          dynamic "volume_mount" {
            for_each = var.stateful_set_volume_claim_template_enabled ? [1] : []

            content {
              name       = var.stateful_set_volume_claim_template_name
              mount_path = "/nexus-data"
              sub_path   = ""
            }
          }
        }
      }
    }

    dynamic "volume_claim_template" {
      for_each = var.stateful_set_volume_claim_template_enabled ? [1] : []

      content {
        metadata {
          name      = var.stateful_set_volume_claim_template_name
          namespace = var.namespace
          annotations = merge(
            {},
            local.annotations,
            var.annotations,
            var.stateful_set_volume_claim_template_annotations
          )
          labels = merge(
            {
              instance  = var.stateful_set_volume_claim_template_name
              component = "storage"
            },
            local.labels,
            var.labels,
            var.stateful_set_volume_claim_template_labels
          )
        }

        spec {
          access_modes       = ["ReadWriteOnce"]
          storage_class_name = var.stateful_set_volume_claim_template_storage_class
          resources {
            requests = {
              storage = var.stateful_set_volume_claim_template_requests_storage
            }
          }
        }
      }
    }
  }
}

#####
# Service
#####

resource "kubernetes_service" "this" {
  count = var.enabled ? 1 : 0

  metadata {
    name      = var.service_name
    namespace = var.namespace
    annotations = merge(
      {},
      local.annotations,
      var.annotations,
      var.service_annotations
    )
    labels = merge(
      {
        "instance"  = var.service_name
        "component" = "network"
      },
      local.labels,
      var.labels,
      var.service_labels
    )
  }

  spec {
    selector = {
      selector = "nexus3-${element(concat(random_string.selector.*.result, list("")), 0)}"
    }

    type = "ClusterIP"

    port {
      port        = local.service_port
      target_port = "http"
      protocol    = "TCP"
      name        = "http"
    }

    dynamic "port" {
      for_each = var.additional_ports

      content {
        port        = port.value.service_port
        protocol    = port.value.protocol
        name        = port.value.name
        target_port = port.value.name
      }
    }
  }
}

#####
# Ingress
#####

resource "kubernetes_ingress" "this" {
  count = var.enabled && var.ingress_enabled ? 1 : 0

  metadata {
    name      = var.ingress_name
    namespace = var.namespace
    annotations = merge(
      local.annotations,
      var.annotations,
      var.ingress_annotations
    )
    labels = merge(
      {
        instance  = var.ingress_name
        component = "network"
      },
      local.labels,
      var.labels,
      var.ingress_labels
    )
  }

  spec {
    backend {
      service_name = element(concat(kubernetes_service.this.*.metadata.0.name, list("")), 0)
      service_port = "http"
    }

    rule {
      host = var.ingress_host
      http {
        path {
          backend {
            service_name = element(concat(kubernetes_service.this.*.metadata.0.name, list("")), 0)
            service_port = "http"
          }
          path = "/"
        }
      }
    }

    dynamic "rule" {
      for_each = var.additional_ports

      content {
        host = value.host
        http {
          path {
            backend {
              service_name = element(concat(kubernetes_service.this.*.metadata.0.name, list("")), 0)
              service_port = value.name
            }
            path = "/"
          }
        }
      }
    }

    dynamic "tls" {
      for_each = var.ingress_tls_enabled ? [1] : []

      content {
        secret_name = var.ingress_tls_secret_name
        hosts       = [var.ingress_host]
      }
    }

    dynamic "tls" {
      for_each = var.ingress_tls_enabled ? var.additional_ports : []

      content {
        secret_name = value.tls_secret_name
        hosts       = [tls.value.host]
      }
    }
  }
}
