#####
# Providers
#####

provider "random" {
  version = "~> 2"
}

provider "kubernetes" {
  version          = "1.10.0"
  load_config_file = true
}

#####
# Randoms
#####

resource "random_string" "this" {
  upper   = false
  number  = false
  special = false
  length  = 8
}

#####
# Context
#####

resource "kubernetes_namespace" "this" {
  metadata {
    name = random_string.this.result
  }
}

#####
# Module
#####

module "this" {
  source = "../.."

  namespace = kubernetes_namesapce.this.metadata.0.name

  additional_ports = [{
    port             = 8082
    protocol         = "TCP"
    name             = "dkr-reg"
    service_port     = 8082
    host             = ""
    ingress_tls_name = ""
  }]
}
