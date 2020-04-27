#####
# Global
#####

output "namespace" {
  value = var.enabled ? var.namespace : ""
}

#####
# Statefulset
#####

output "statefulset" {
  value = element(concat(kubernetes_stateful_set.this.*, list({})), 0)
}

#####
# Service
#####

output "service" {
  value = element(concat(kubernetes_service.this.*, list({})), 0)
}

#####
# Ingress
#####

output "ingress" {
  value = element(concat(kubernetes_ingress.this.*, list({})), 0)
}
