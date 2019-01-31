#===========================#
# NSX Variables             #
#===========================#

## Global provider variables
variable "NSX_MANAGER" {
  type        = "string"
  description = "NSX Manager URL/IP Address"
}

variable "NSX_USER" {
  type = "string"
}

variable "NSX_PASSWORD" {
  type = "string"
}

variable "TRUST_SSL_CERT" {
  type        = "string"
  description = "whether to trust ssl cert presented by server"
}

variable "TZ_OVERLAY" {
  type        = "string"
  description = "name of the overlay transport zone"
}

variable "EDGE_CLUSTER" {
  type        = "string"
  description = "name of the nsx edge cluster"
}

variable "T0_RTR" {
  type        = "string"
  description = "name of the T0 router"
}

## Compute Scope and Tags

variable "COMP_SCOPE" {
  type        = "string"
  description = "name of the comp scope"
}

variable "COMP_TAG" {
  type        = "string"
  description = "name of the comp tag"
}

variable "API_TAG" {
  type        = "string"
  description = "name of the api tag"
}

## Kube K8s Worker Node Topology Variables

variable "T1_K8S_NAME" {
  type        = "string"
  description = "name of the Kube K8S T1 router"
}

variable "T0_K8S_RP" {
  type        = "string"
  description = "Port to connect Kube K8S T1 to T0"
}

variable "LS_K8S_NAME" {
  type        = "string"
  description = "name of the Kube K8S logical switch"
}

variable "LP_K8S_NAME" {
  type        = "string"
  description = "name of the Kube K8S port on K8S logical switch"
}

variable "T1_K8S_IP_NET" {
  type        = "string"
  description = "K8s network gateway address"
}

## Loadbalancer variables

variable "KUBE_API_NSG" {
  type        = "string"
  description = "NSG Display Name"
}

variable "LB_SIZE" {
  type        = "string"
  description = "Size of NSX LBer"
}

variable "T1_LB_NAME" {
  type        = "string"
  description = "Name of the T1 LBer"
}

variable "T0_LB_RP" {
  type        = "string"
  description = "Name of the router port"
}

variable "LS_LB_NAME" {
  type        = "string"
  description = "name of the Kube LB logical switch"
}

variable "LP_LB_NAME" {
  type        = "string"
  description = "name of the Kube LB port on LB logical switch"
}

variable "T1_LB_IP_NET" {
  type        = "string"
  description = "LB network gateway address"
}

variable "LB_ALGORITHM" {
  type        = "string"
  description = "Which LBing algorithm to use ROUND_ROBIN, WEIGHTED_ROUND_ROBIN, LEAST_CONNECTION, WEIGHTED_LEAST_CONNECTION, IP_HASH"
}

variable "KUBE_API_PORT" {
  type        = "string"
  description = "Kube API Port"
}

variable "KUBE_VS_NAME" {
  type        = "string"
  description = "LBer Virtual Server Display Name"
}

variable "KUBE_VIP" {
  type        = "string"
  description = "LBer VIP address"
}

variable "KUBE_LB_NAME" {
  type        = "string"
  description = "LBer Display Name"
}