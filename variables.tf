#####
# Global
#####

variable "enabled" {
  description = "Whether or not to enable this module."
  default     = true
}

variable "namespace" {
  description = "Name of the namespace in which to deploy the module."
  default     = "default"
}

variable "annotations" {
  description = "Map of annotations that will be applied on all resources."
  default     = {}
}

variable "labels" {
  description = "Map of labels that will be applied on all resources."
  default     = {}
}

#####
# Application
#####

variable "image" {
  description = "Image to use."
  default     = "fxinnovation/nexus3"
}

variable "image_version" {
  description = "Version of the image to use."
  default     = "master"
}

variable "resources_requests_cpu" {
  description = "Amount of cpu time that the application requests."
  default     = "300m"
}

variable "resource_requests_memory" {
  description = "Amount of memory that the application requests."
  default     = "1200Mi"
}

variable "resources_limits_cpu" {
  description = "Amount of cpu time that the application limits."
  default     = "1"
}

variable "resource_limits_memory" {
  description = "Amount of memory that the application limits."
  default     = "2048Mi"
}

variable "additional_ports" {
  description = "Map of additional port on which you will configure nexus to listen on. To be used for some repository types which needs specific URL's (like a docker registry). All fields must be defined."
  type = list(object({
    port             = Number # Port number on which nexus will be listening
    protocol         = String # One of TCP or UDP
    name             = String # Name you want to that port (ex: dkr-reg)
    service_port     = Number # Port number on which the service will be listening (can be the same as port)
    host             = String # Host to which that port matches (ex: registry.example.com). Set to empty string if you're not using an ingress
    ingress_tls_name = String # Name of the secret that will hold the TLS certificate. Set to empty sdtring if you're not using TLS on the ingress
  }))
}


#####
# StatefulSet
#####

variable "stateful_set_name" {
  description = "Name of the statefulset to deploy."
  default     = "nexus3"
}

variable "stateful_set_annotations" {
  description = "Map of annotations that will be applied on the statefulset."
  default     = {}
}

variable "stateful_set_labels" {
  description = "Map of labels that will be applied on the statefulset."
  default     = {}
}

variable "stateful_set_template_annotations" {
  description = "Map of annotations that will be applied on the statefulset template."
  default     = {}
}

variable "stateful_set_template_labels" {
  description = "Map of labels that will be applied on the statefulset template."
  default     = {}
}

variable "stateful_set_volume_claim_template_enabled" {
  description = "Whether or not to enable the volume claim template on the statefulset."
  default     = true
}

variable "stateful_set_volume_claim_template_annotations" {
  description = "Map of annotations that will be applied on the statefulset volume claim template."
  default     = {}
}

variable "stateful_set_volume_claim_template_labels" {
  description = "Map of labels that will be applied on the statefulset volume claim template."
  default     = {}
}

variable "stateful_set_volume_claim_template_name" {
  description = "Name of the statefulset's volume claim template."
  default     = "nexus3"
}

variable "stateful_set_volume_claim_template_storage_class" {
  description = "Storage class to use for the stateful set volume claim template."
  default     = null
}

variable "stateful_set_volume_claim_template_storage_requests" {
  description = "Size of storage the stateful set volume claim template requests."
  default     = "1024Gi"
}

#####
# Service
#####

variable "service_name" {
  description = "Name of the service."
  default     = "nexus3"
}

variable "service_annotations" {
  description = "Map of annotations that will be applied on the service."
  default     = {}
}

variable "service_labels" {
  description = "Map of labels that will be applied on the service."
  default     = {}
}

#####
# Ingress
#####

variable "ingress_enabled" {
  description = "Whether or not to enable the ingress."
  default     = true
}

variable "ingress_name" {
  description = "Name of the ingress."
  default     = "nexus3"
}

variable "ingress_annotations" {
  description = "Map of annotations that will be applied on the ingress."
  default     = {}
}

variable "ingress_labels" {
  description = "Map of labels that will be applied on the ingress."
  default     = {}
}

variable "ingress_host" {
  description = "Host on which the ingress wil be available (ex: nexus.example.com)."
  type        = string
  default     = null
}

variable "ingress_tls_enabled" {
  description = "Whether or not TLS should be enabled on the ingress."
  default     = true
}

variable "ingress_tls_secret_name" {
  description = "Name of the secret to use to put TLS on the ingress."
  default     = "nexus3"
}
