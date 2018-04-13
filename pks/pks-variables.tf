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

## Create MGMT and Compute SNAT Rules

variable "MGMT_SNAT" {
  type        = "string"
  description = "name of the mgmt snat rule"
}

variable "MGMT_SOURCE" {
  type        = "string"
  description = "source mgmt network"
}

variable "MGMT_TNET" {
  type        = "string"
  description = "translated ip for the mgmt network"
}

variable "COMP_SNAT" {
  type        = "string"
  description = "name of the compute snat rule"
}

variable "COMP_SOURCE" {
  type        = "string"
  description = "source compute network"
}

variable "COMP_TNET" {
  type        = "string"
  description = "translated ip for the compute network"
}

## Create MGMT DNAT Rules

variable "OPS_MAN_DNAT" {
  type        = "string"
  description = "name of the ops-manager dnat"
}

variable "OPS_MAN_TIP" {
  type        = "string"
  description = "ops manager ip address"
}

variable "OPS_MAN_DIP" {
  type        = "string"
  description = "ops manager translated ip address"
}

variable "BOSH_DNAT" {
  type        = "string"
  description = "name of the bosh dnat"
}

variable "BOSH_TIP" {
  type        = "string"
  description = "bosh ip address"
}

variable "BOSH_DIP" {
  type        = "string"
  description = "bosh translated ip address"
}

variable "PKS_CTRL_DNAT" {
  type        = "string"
  description = "name of the pks controller dnat"
}

variable "PKS_CTRL_TIP" {
  type        = "string"
  description = "pks controller ip address"
}

variable "PKS_CTRL_DIP" {
  type        = "string"
  description = "pks controller translated ip address"
}

variable "HARBOR_DNAT" {
  type        = "string"
  description = "name of the harbor dnat"
}

variable "HARBOR_TIP" {
  type        = "string"
  description = "harbor ip address"
}

variable "HARBOR_DIP" {
  type        = "string"
  description = "harbor translated ip address"
}

## PKS MGMT Topology Variables

variable "T1_MGMT_NAME" {
  type        = "string"
  description = "name of the PKS MGMT T1 router"
}

variable "T0_MGMT_RP" {
  type        = "string"
  description = "Port to connect PKS MGMT T1 to T0"
}

variable "LS_MGMT_NAME" {
  type        = "string"
  description = "name of the PKS MGMT logical switch"
}

variable "LP_MGMT_NAME" {
  type        = "string"
  description = "name of the PKS MGMT port on MGMT logical switch"
}

variable "T1_MGMT_IP_NET" {
  type        = "string"
  description = "MGMT network gateway address"
}

## PKS K8s Worker Node Topology Variables

variable "T1_K8S_NAME" {
  type        = "string"
  description = "name of the PKS K8S T1 router"
}

variable "T0_K8S_RP" {
  type        = "string"
  description = "Port to connect PKS K8S T1 to T0"
}

variable "LS_K8S_NAME" {
  type        = "string"
  description = "name of the PKS K8S logical switch"
}

variable "LP_K8S_NAME" {
  type        = "string"
  description = "name of the PKS K8S port on K8S logical switch"
}

variable "T1_K8S_IP_NET" {
  type        = "string"
  description = "K8s network gateway address"
}
