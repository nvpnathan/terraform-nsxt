## Global Provider and Data Variables
NSX_MANAGER = "192.168.64.20"

NSX_USER = "admin"

NSX_PASSWORD = "VMware1!"

TRUST_SSL_CERT = "true"

## NSX Data collection

TZ_OVERLAY = "overlay-tz"

TZ_VLAN = "vlan-tz"

EDGE_CLUSTER = "edge-cluster-1"

## T0 Uplink VLAN LS

T0_UPLINK_VLAN_NAME = "uplink-vlan-ls"

T0_UPLINK_VLAN_ID = "0"

T0_UPLINK_SCOPE = "PKS"

T0_UPLINK_TAG = "T0-Uplink"

## T0 Router

T0_RTR = "t0-pks"

T0_SCOPE = "PKS"

T0_TAG = "T0"

## T0 Default Route (STATIC)

T0_DEFAULT_ROUTE = "pks t0 default route"

T0_ROUTE_SCOPE = "t0-pks-route"

T0_ROUTE_TAG = "default"

T0_DEFAULT_ROUTE_NEXT_HOP_IP = "192.168.71.1"

## T0 Ports

T0_UPLINK1_IP = "192.168.71.8/24"

T0_UPLINK2_IP = "192.168.71.9/24"

## MGMT Scope and Tag

MGMT_SCOPE = "pks"

MGMT_TAG = "mgmt"

## Compute Scope and Tag

COMP_SCOPE = "pks"

COMP_TAG = "k8s"

## PKS MGMT Topology Variables

T1_MGMT_NAME = "t1-pks-mgmt"

T0_MGMT_RP = "t0-mgmt-rp"

LS_MGMT_NAME = "ls-pks-mgmt"

LP_MGMT_NAME = "lp-mgmt-pks"

T1_MGMT_IP_NET = "172.31.0.1/24"

## Data Services Topology Variables

T1_DATA_SVCS_NAME = "t1-data-services"

T0_DATA_SVCS_RP = "t0-service-rp"

LS_DATA_SVCS_NAME = "ls-data-services"

LP_DATA_SVCS_NAME = "lp-data-services"

T1_DATA_SVCS_IP_NET = "172.31.2.1/24"

## IP Block variables

NODE_IP_BLOCK = "ip-block-pks-node-snat"

NODE_IP_BLOCK_CIDR = "172.15.0.0/16"

POD_IP_BLOCK = "ip-block-pks-pod-snat"

POD_IP_BLOCK_CIDR = "172.16.0.0/16"

## VIP Pool variables

IP_POOL_PKS_VIPS1 = "ip-pool1-vips"

POOL1_SCOPE = "PKS"

POOL1_TAG = "POOL"

VIP_IP_POOL1_RANGE = "192.168.75.10-192.168.75.250" 

VIP_IP_POOL1_CIDR = "192.168.75.0/24"