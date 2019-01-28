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

variable "T0_RTR" {
  type        = "string"
  description = "name of the T0 router"
}

variable "TZ_OVERLAY" {
  type        = "string"
  description = "name of the overlay transport zone"
}

variable "EDGE_CLUSTER" {
  type        = "string"
  description = "name of the nsx edge cluster"
}

## MGMT Scope and Tag

variable "MGMT_SCOPE" {
  type        = "string"
  description = "name of the mgmt scope"
}

variable "MGMT_TAG" {
  type        = "string"
  description = "name of the mgmt tag"
}

## Compute Scope and Tag

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

## PKS K8s Worker Node Topology Variables

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
variable "LB_ALGORITHM" {
  type        = "string"
  description = "Which LBing algorithm to use"
}