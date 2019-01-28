## Global Provider and Data Variables
NSX_MANAGER = "192.168.64.20"

NSX_USER = "admin"

NSX_PASSWORD = "VMware1!"

TRUST_SSL_CERT = "true"

T0_RTR = "t0-pks"

TZ_OVERLAY = "overlay-tz"

EDGE_CLUSTER = "edge-cluster-1"

## Compute Scope and Tags

COMP_SCOPE = "kube"

COMP_TAG = "k8s"

API_TAG = "api"

## PKS K8s Worker Node Topology Variables

T1_K8S_NAME = "t1-kube-cluster"

T0_K8S_RP = "t0-kube-rp"

LS_K8S_NAME = "ls-kube-cluster"

LP_K8S_NAME = "lp-pks-cluster"

T1_K8S_IP_NET = "192.168.77.1/24"

## Kube API LBer Variables

LB_SIZE = "SMALL"

T1_LB_NAME = "kube-lb"

T0_LB_RP = "t0-lb-rp"

LB_ALGORITHM = "LEAST_CONNECTION"