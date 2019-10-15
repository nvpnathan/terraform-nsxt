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

## NSX Data Collection

variable "TZ_OVERLAY" {
  type        = "string"
  description = "name of the overlay transport zone"
}

variable "TZ_VLAN" {
  type        = "string"
  description = "name of the vlan transport zone"
}

variable "EDGE_CLUSTER" {
  type        = "string"
  description = "name of the nsx edge cluster"
}

## Uplink VLAN LS

variable "T0_UPLINK_VLAN_NAME" {
  type        = "string"
  description = "Name of the T0 VLAN Uplink Logical Switch"
}

variable "T0_UPLINK_VLAN_ID" {
  type        = "string"
  description = "T0 Uplink VLAN ID"
}

variable "T0_UPLINK_SCOPE" {
  type        = "string"
  description = "T0 Scope value"
}

variable "T0_UPLINK_TAG" {
  type        = "string"
  description = "T0 Tag value"
}

## T0 Router
variable "T0_RTR" {
  type        = "string"
  description = "Display name of the T0 router"
}

variable "T0_SCOPE" {
  type        = "string"
  description = "T0 Scope value"
}

variable "T0_TAG" {
  type        = "string"
  description = "T0 Tag value"
}

## Default Route for the T0 Router

variable "T0_DEFAULT_ROUTE" {
  type        = "string"
  description = "Display name of the T0 Default Router"
}

variable "T0_DEFAULT_ROUTE_NEXT_HOP_IP" {
  type        = "string"
  description = "Gateway of the Physical Router"
}

variable "T0_ROUTE_SCOPE" {
  type        = "string"
  description = "T0 Route Scope value"
}

variable "T0_ROUTE_TAG" {
  type        = "string"
  description = "T0 Route Tag value"
}

## T0 Router Ports

variable "T0_UPLINK1_IP" {
  type        = "string"
  description = "T0 Uplink 1 IP 1.1.1.1/24 format"
}

variable "T0_UPLINK2_IP" {
  type        = "string"
  description = "T0 Uplink 2 IP 1.1.1.2/24 format"
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

## Create MGMT DNAT Rules

variable "OPSMAN_DNAT" {
  type        = "string"
  description = "name of the ops-manager dnat"
}

variable "OPSMAN_TIP" {
  type        = "string"
  description = "ops manager ip address"
}

variable "OPSMAN_DIP" {
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

## PKS Data Services Topology Variables

variable "T1_DATA_SVCS_NAME" {
  type        = "string"
  description = "Display Name of the PKS Data Services T1 router"
}

variable "T0_DATA_SVCS_RP" {
  type        = "string"
  description = "Port to connect PKS Data Services T1 to T0"
}

variable "LS_DATA_SVCS_NAME" {
  type        = "string"
  description = "Display Name of the Data Services logical switch"
}

variable "LP_DATA_SVCS_NAME" {
  type        = "string"
  description = "Display Name of the Data Services port on Data Services logical switch"
}

variable "T1_DATA_SVCS_IP_NET" {
  type        = "string"
  description = "Data Services network gateway address"
}

## IP Block variables

variable "NODE_IP_BLOCK" {
  type        = "string"
  description = "Display name of the Nodes IP Block"
}

variable "NODE_IP_BLOCK_CIDR" {
  type        = "string"
  description = "CIDR format for the Nodes IP Block"
}

variable "POD_IP_BLOCK" {
  type        = "string"
  description = "Display name of the Pods IP Block"
}

variable "POD_IP_BLOCK_CIDR" {
  type        = "string"
  description = "CIDR format for the Pods IP Block"
}

variable "ROUTABLE_POD_IP_BLOCK" {
  type        = "string"
  description = "Display name of the Pods IP Block"
}

variable "ROUTABLE_POD_IP_BLOCK_CIDR" {
  type        = "string"
  description = "CIDR format for the Pods IP Block"
}

## VIP Pool variables

variable "IP_POOL_PKS_VIPS1" {
  type        = "string"
  description = "Display name of the Pods IP Block Subnet"
}

variable "POOL1_SCOPE" {
  type        = "string"
  description = "Pod Scope value"
}

variable "POOL1_TAG" {
  type        = "string"
  description = "Pod Tag value"
}

variable "VIP_IP_POOL1_RANGE" {
  type        = "string"
  description = "IP Pool range 1.1.1.10-1.1.1.250 format"
}

variable "VIP_IP_POOL1_CIDR" {
  type        = "string"
  description = "IP Pool CIDR for the Range"
}

variable "SEC_VIP_IP_POOL2_CIDR" {
  type        = "string"
  description = "IP Pool CIDR for the Range"
}

variable "SEC_IP_POOL_PKS_VIPS2" {
  type        = "string"
  description = "Display name of the Pods IP Block Subnet"
}

variable "POOL2_SCOPE" {
  type        = "string"
  description = "Pod Scope value"
}

variable "POOL2_TAG" {
  type        = "string"
  description = "Pod Tag value"
}

variable "SEC_VIP_IP_POOL2_RANGE" {
  type        = "string"
  description = "IP Pool range 1.1.1.10-1.1.1.250 format"
}

variable "ENV_NAME" {
  type        = "string"
  description = "Environment Name"
}