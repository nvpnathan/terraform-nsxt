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

variable "T1_MGMT_GTWY" {
  type        = "string"
  description = "MGMT network gateway address"
}

variable "T1_MGMT_PREFIX" {
  type        = "string"
  description = "MGMT network prefix length"
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

variable "T1_K8S_GTWY" {
  type        = "string"
  description = "K8s network gateway address"
}

variable "T1_K8S_PREFIX" {
  type        = "string"
  description = "K8s network prefix length"
}
