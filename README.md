# terraform-module-kubernetes-nexus3

Terraform module to deploy nexus3 on kubernetes. This module only allows for a single node nexus3 deployed in a statefulset.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| kubernetes | >= 1.10.0 |
| random | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| kubernetes | >= 1.10.0 |
| random | >= 2.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_ports | Map of additional port on which you will configure nexus to listen on. To be used for some repository types which needs specific URL's (like a docker registry). All fields must be defined. | <pre>list(object({<br>    port             = number # Port number on which nexus will be listening<br>    protocol         = string # One of TCP or UDP<br>    name             = string # Name you want to that port (ex: dkr-reg)<br>    service_port     = number # Port number on which the service will be listening (can be the same as port)<br>    host             = string # Host to which that port matches (ex: registry.example.com). Set to empty string if you're not using an ingress<br>    ingress_tls_name = string # Name of the secret that will hold the TLS certificate. Set to empty sdtring if you're not using TLS on the ingress<br>  }))</pre> | `[]` | no |
| annotations | Map of annotations that will be applied on all resources. | `map` | `{}` | no |
| enabled | Whether or not to enable this module. | `bool` | `true` | no |
| image | Image to use. | `string` | `"fxinnovation/nexus3"` | no |
| image\_version | Version of the image to use. | `string` | `"master"` | no |
| ingress\_annotations | Map of annotations that will be applied on the ingress. | `map` | `{}` | no |
| ingress\_enabled | Whether or not to enable the ingress. | `bool` | `true` | no |
| ingress\_host | Host on which the ingress wil be available (ex: nexus.example.com). | `string` | `"example.com"` | no |
| ingress\_labels | Map of labels that will be applied on the ingress. | `map` | `{}` | no |
| ingress\_name | Name of the ingress. | `string` | `"nexus3"` | no |
| ingress\_tls\_enabled | Whether or not TLS should be enabled on the ingress. | `bool` | `true` | no |
| ingress\_tls\_secret\_name | Name of the secret to use to put TLS on the ingress. | `string` | `"nexus3"` | no |
| labels | Map of labels that will be applied on all resources. | `map` | `{}` | no |
| namespace | Name of the namespace in which to deploy the module. | `string` | `"default"` | no |
| resources\_limits\_cpu | Amount of cpu time that the application limits. | `string` | `"1"` | no |
| resources\_limits\_memory | Amount of memory that the application limits. | `string` | `"2048Mi"` | no |
| resources\_requests\_cpu | Amount of cpu time that the application requests. | `string` | `"300m"` | no |
| resources\_requests\_memory | Amount of memory that the application requests. | `string` | `"1200Mi"` | no |
| service\_annotations | Map of annotations that will be applied on the service. | `map` | `{}` | no |
| service\_labels | Map of labels that will be applied on the service. | `map` | `{}` | no |
| service\_name | Name of the service. | `string` | `"nexus3"` | no |
| stateful\_set\_annotations | Map of annotations that will be applied on the statefulset. | `map` | `{}` | no |
| stateful\_set\_labels | Map of labels that will be applied on the statefulset. | `map` | `{}` | no |
| stateful\_set\_name | Name of the statefulset to deploy. | `string` | `"nexus3"` | no |
| stateful\_set\_template\_annotations | Map of annotations that will be applied on the statefulset template. | `map` | `{}` | no |
| stateful\_set\_template\_labels | Map of labels that will be applied on the statefulset template. | `map` | `{}` | no |
| stateful\_set\_volume\_claim\_template\_annotations | Map of annotations that will be applied on the statefulset volume claim template. | `map` | `{}` | no |
| stateful\_set\_volume\_claim\_template\_enabled | Whether or not to enable the volume claim template on the statefulset. | `bool` | `true` | no |
| stateful\_set\_volume\_claim\_template\_labels | Map of labels that will be applied on the statefulset volume claim template. | `map` | `{}` | no |
| stateful\_set\_volume\_claim\_template\_name | Name of the statefulset's volume claim template. | `string` | `"nexus3"` | no |
| stateful\_set\_volume\_claim\_template\_requests\_storage | Size of storage the stateful set volume claim template requests. | `string` | `"1Ti"` | no |
| stateful\_set\_volume\_claim\_template\_storage\_class | Storage class to use for the stateful set volume claim template. | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| ingress | n/a |
| namespace\_name | n/a |
| service | n/a |
| statefulset | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
