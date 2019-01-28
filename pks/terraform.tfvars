## Global Provider and Data Variables
NSX_MANAGER = "192.168.64.20"

NSX_USER = "admin"

NSX_PASSWORD = "VMware1!"

TRUST_SSL_CERT = "true"

T0_RTR = "t0-pks"

TZ_OVERLAY = "overlay-tz"

EDGE_CLUSTER = "edge-cluster-1"

## MGMT Scope and Tag

MGMT_SCOPE = "pks"

MGMT_TAG = "mgmt"

## Compute Scope and Tag

COMP_SCOPE = "pks"

COMP_TAG = "k8s"

## Create MGMT and Compute SNAT Rules

MGMT_SNAT = "pks-mgmt-snat"

MGMT_SOURCE = "172.31.0.0/24"

MGMT_TNET = "192.168.76.1"

COMP_SNAT = "pks-comp-snat"

COMP_SOURCE = "172.31.2.0/23"

COMP_TNET = "192.168.76.50"

## Create MGMT DNAT Rules

OPS_MAN_DNAT = "Ops-Man-DNAT"

OPS_MAN_TIP = "172.31.0.2"

OPS_MAN_DIP = "192.168.76.2"

BOSH_DNAT = "PKS-Controller-DNAT"

BOSH_TIP = "172.31.0.3"

BOSH_DIP = "192.168.76.3"

PKS_CTRL_DNAT = "PKS-Controller-DNAT"

PKS_CTRL_TIP = "172.31.0.4"

PKS_CTRL_DIP = "192.168.76.4"

HARBOR_DNAT = "Harbor-DNAT"

HARBOR_TIP = "172.31.0.5"

HARBOR_DIP = "192.168.76.5"

## PKS MGMT Topology Variables

T1_MGMT_NAME = "t1-pks-mgmt"

T0_MGMT_RP = "t0-mgmt-rp"

LS_MGMT_NAME = "ls-pks-mgmt"

LP_MGMT_NAME = "lp-mgmt-pks"

T1_MGMT_IP_NET = "172.31.0.1/24"

## PKS K8s Worker Node Topology Variables

T1_K8S_NAME = "t1-pks-service"

T0_K8S_RP = "t0-service-rp"

LS_K8S_NAME = "ls-pks-service"

LP_K8S_NAME = "lp-pks-service"

T1_K8S_IP_NET = "172.31.2.1/23"
