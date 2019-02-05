## Connect to NSX Manager.
provider "nsxt" {
  host                 = "${var.NSX_MANAGER}"
  username             = "${var.NSX_USER}"
  password             = "${var.NSX_PASSWORD}"
  allow_unverified_ssl = "${var.TRUST_SSL_CERT}"
}

## Collect data
data "nsxt_transport_zone" "TZ-OVERLAY" {
  display_name = "${var.TZ_OVERLAY}"
}

data "nsxt_transport_zone" "TZ-VLAN" {
  display_name = "${var.TZ_VLAN}"
  transport_type = "VLAN"
}

#data "nsxt_logical_tier0_router" "T0" {
#  display_name = "${var.T0_RTR}"
#}

data "nsxt_edge_cluster" "EDGE-CLUSTER" {
  display_name = "${var.EDGE_CLUSTER}"
}

## Create Uplink VLAN LS

resource "nsxt_vlan_logical_switch" "T0_UPLINK_VLAN_LS" {
  description       = "T0 Uplink VLAN LS provisioned by Terraform"
  display_name      = "${var.T0_UPLINK_VLAN_NAME}"
  transport_zone_id = "${data.nsxt_transport_zone.TZ-VLAN.id}"
  vlan              = "${var.T0_UPLINK_VLAN_ID}"

  tag = {
    scope = "${var.T0_UPLINK_SCOPE}"
    tag   = "${var.T0_UPLINK_TAG}"
  }
}

## Create T0 Router

resource "nsxt_logical_tier0_router" "TIER0_ROUTER" {
  display_name           = "${var.T0_RTR}"
  description            = "ACTIVE-STANDBY Tier0 router provisioned by Terraform"
  high_availability_mode = "ACTIVE_STANDBY"
  edge_cluster_id        = "${data.nsxt_edge_cluster.EDGE-CLUSTER.id}"

  tag {
    scope = "${var.T0_SCOPE}"
    tag   = "${var.T0_TAG}"
  }
}

resource "nsxt_static_route" "static_route" {
  description       = "SR provisioned by Terraform"
  display_name      = "${var.T0_DEFAULT_ROUTE}"
  logical_router_id = "${nsxt_logical_tier0_router.TIER0_ROUTER.id}"
  network           = "0.0.0.0/0"

  next_hop {
    ip_address              = "${var.T0_DEFAULT_ROUTE_NEXT_HOP_IP}"
    administrative_distance = "1"
  }

  tag {
    scope = "${var.T0_ROUTE_SCOPE}"
    tag   = "${var.T0_ROUTE_TAG}"
  }
}

#resource "nsxt_logical_port" "LOGICAL_PORT_UPLINK1" {
#  admin_state       = "UP"
#  description       = "LP1 provisioned by Terraform"
#  display_name      = "lsp_for_uplink_1"
#  logical_switch_id = "${nsxt_logical_switch.T0_UPLINK_VLAN_LS.id}"

#  tag {
#    scope = "PKS"
#    tag   = "PORT"
#  }
#}

#resource "nsxt_logical_router_link_port_on_tier0" "TIER0_LINK_PORT1" {
#  description                   = "TIER0_PORT1 provisioned by Terraform"
#  display_name                  = "t0_uplink_1"
#  logical_router_id             = "${nsxt_logical_tier0_router.TIER0_ROUTER.id}"

#  tag {
#    scope = "PKS"
#    tag   = "T0PORT1"
#  }
#}

#resource "nsxt_logical_port" "LOGICAL_PORT_UPLINK2" {
#  admin_state       = "UP"
#  description       = "LP1 provisioned by Terraform"
#  display_name      = "lsp_for_uplink_2"
#  logical_switch_id = "${nsxt_logical_switch.T0_UPLINK_VLAN_LS.id}"

#  tag {
#    scope = "PKS"
#    tag   = "PORT"
#  }
#}

#resource "nsxt_logical_router_link_port_on_tier0" "TIER0_LINK_PORT2" {
#  description                   = "TIER0_PORT1 provisioned by Terraform"
#  display_name                  = "t0_uplink_2"
#  logical_router_id             = "${nsxt_logical_tier0_router.TIER0_ROUTER.id}"

#  tag {
#    scope = "PKS"
#    tag   = "T0PORT1"
#  }
#}

## Create MGMT and Compute SNAT Rules
resource "nsxt_nat_rule" "MGMT_SNAT" {
  logical_router_id    = "${nsxt_logical_tier0_router.TIER0_ROUTER.id}"
  description          = "PKS MGMT NAT provisioned by Terraform"
  display_name         = "${var.MGMT_SNAT}"
  action               = "SNAT"
  enabled              = true
  logging              = false
  nat_pass             = true
  translated_network   = "${var.MGMT_TNET}"
  match_source_network = "${var.MGMT_SOURCE}"

  tag {
    scope = "${var.MGMT_SCOPE}"
    tag   = "${var.MGMT_TAG}"
  }
}

## Create MGMT DNAT Rules
resource "nsxt_nat_rule" "OPSMAN_DNAT" {
  logical_router_id         = "${nsxt_logical_tier0_router.TIER0_ROUTER.id}"
  description               = "PKS Ops-Man DNAT provisioned by Terraform"
  display_name              = "${var.OPSMAN_DNAT}"
  action                    = "DNAT"
  enabled                   = true
  logging                   = false
  nat_pass                  = true
  translated_network        = "${var.OPSMAN_TIP}"
  match_destination_network = "${var.OPSMAN_DIP}"

  tag {
    scope = "${var.MGMT_SCOPE}"
    tag   = "${var.MGMT_TAG}"
  }
}

resource "nsxt_nat_rule" "BOSH_DNAT" {
  logical_router_id         = "${nsxt_logical_tier0_router.TIER0_ROUTER.id}"
  description               = "PKS BOSH DNAT provisioned by Terraform"
  display_name              = "${var.BOSH_DNAT}"
  action                    = "DNAT"
  enabled                   = true
  logging                   = false
  nat_pass                  = true
  translated_network        = "${var.BOSH_TIP}"
  match_destination_network = "${var.BOSH_DIP}"

  tag {
    scope = "${var.MGMT_SCOPE}"
    tag   = "${var.MGMT_TAG}"
  }
}

resource "nsxt_nat_rule" "PKS_CTRL_DNAT" {
  logical_router_id         = "${nsxt_logical_tier0_router.TIER0_ROUTER.id}"
  description               = "PKS Controller DNAT provisioned by Terraform"
  display_name              = "${var.PKS_CTRL_DNAT}"
  action                    = "DNAT"
  enabled                   = true
  logging                   = false
  nat_pass                  = true
  translated_network        = "${var.PKS_CTRL_TIP}"
  match_destination_network = "${var.PKS_CTRL_DIP}"

  tag {
    scope = "${var.MGMT_SCOPE}"
    tag   = "${var.MGMT_TAG}"
  }
}

resource "nsxt_nat_rule" "HARBOR_DNAT" {
  logical_router_id         = "${nsxt_logical_tier0_router.TIER0_ROUTER.id}"
  description               = "PKS Harbor DNAT provisioned by Terraform"
  display_name              = "${var.HARBOR_DNAT}"
  action                    = "DNAT"
  enabled                   = true
  logging                   = false
  nat_pass                  = true
  translated_network        = "${var.HARBOR_TIP}"
  match_destination_network = "${var.HARBOR_DIP}"

  tag {
    scope = "${var.MGMT_SCOPE}"
    tag   = "${var.MGMT_TAG}"
  }
}

## Create PKS MGMT T1 Router.
resource "nsxt_logical_tier1_router" "T1-MGMT" {
  description                 = "T1 provisioned by Terraform"
  display_name                = "${var.T1_MGMT_NAME}"
  enable_router_advertisement = "true"
  advertise_connected_routes  = "true"
  failover_mode = "PREEMPTIVE"

  tag = [{
    scope = "${var.MGMT_SCOPE}"
    tag   = "${var.MGMT_TAG}"
  }]
}

## Connect PKS MGMT T1 to T0.
resource "nsxt_logical_router_link_port_on_tier0" "T0-MGMT-RP" {
  # description = "${nsxt_logical_router_link_port_on_tier0.T0-RP.display_name} to ${nsxt_logical_router_link_port_on_tier1.T1-RP.display_name}"
  display_name      = "${var.T0_MGMT_RP}"
  logical_router_id = "${nsxt_logical_tier0_router.TIER0_ROUTER.id}"

  tag = [{
    scope = "${var.MGMT_SCOPE}"
    tag   = "${var.MGMT_TAG}"
  }]
}

resource "nsxt_logical_router_link_port_on_tier1" "T1-MGMT-RP" {
  # description = "${nsxt_logical_router_link_port_on_tier0.T0-RP.display_name} to ${nsxt_logical_router_link_port_on_tier1.T1-RP.display_name}"
  display_name                  = "T1-MGMT-RP"
  logical_router_id             = "${nsxt_logical_tier1_router.T1-MGMT.id}"
  linked_logical_router_port_id = "${nsxt_logical_router_link_port_on_tier0.T0-MGMT-RP.id}"

  tag = [{
    scope = "${var.MGMT_SCOPE}"
    tag   = "${var.MGMT_TAG}"
  }]
}

## Create PKS MGMT Logical Switch
resource "nsxt_logical_switch" "LS-MGMT-PKS" {
  count             = 1
  admin_state       = "UP"
  description       = "PKS mgmt provisioned by Terraform"
  display_name      = "${var.LS_MGMT_NAME}"
  transport_zone_id = "${data.nsxt_transport_zone.TZ-OVERLAY.id}"
  replication_mode  = "MTEP"

  tag = [{
    scope = "${var.MGMT_SCOPE}"
    tag   = "${var.MGMT_TAG}"
  }]
}

## Create ports on respective LS.
resource "nsxt_logical_port" "LP-MGMT-PKS" {
  count             = 1
  admin_state       = "UP"
  description       = "LP-MGMT provisioned by Terraform"
  display_name      = "${var.LP_MGMT_NAME}"
  logical_switch_id = "${nsxt_logical_switch.LS-MGMT-PKS.id}"

  tag = [{
    scope = "${var.MGMT_SCOPE}"
    tag   = "${var.MGMT_TAG}"
  }]
}

## Create PKS MGMT LIF on PKS T1 DLR.
resource "nsxt_logical_router_downlink_port" "MGMT_DP1" {
  count                         = 1
  description                   = "LIF-MGMT provisioned by Terraform"
  display_name                  = "LIF-MGMT"
  logical_router_id             = "${nsxt_logical_tier1_router.T1-MGMT.id}"
  linked_logical_switch_port_id = "${nsxt_logical_port.LP-MGMT-PKS.id}"
  ip_address                    = "${var.T1_MGMT_IP_NET}"

  tag = [{
    scope = "${var.MGMT_SCOPE}"
    tag   = "${var.MGMT_TAG}"
  }]
}

## Create Data Services T1 Router.
resource "nsxt_logical_tier1_router" "T1-DATA-SVCS" {
  description                 = "T1 provisioned by Terraform"
  display_name                = "${var.T1_DATA_SVCS_NAME}"
  enable_router_advertisement = "true"
  advertise_connected_routes  = "true"

  tag = {
    scope = "${var.COMP_SCOPE}"
    tag   = "${var.COMP_TAG}"
  }
}

## Connect Data Services T1 to T0.
resource "nsxt_logical_router_link_port_on_tier0" "T0-DATA-SVCS-RP" {
  # description = "${nsxt_logical_router_link_port_on_tier0.T0-RP.display_name} to ${nsxt_logical_router_link_port_on_tier1.T1-RP.display_name}"
  display_name      = "${var.T0_DATA_SVCS_RP}"
  logical_router_id = "${nsxt_logical_tier0_router.TIER0_ROUTER.id}"

  tag = {
    scope = "${var.COMP_SCOPE}"
    tag   = "${var.COMP_TAG}"
  }
}

resource "nsxt_logical_router_link_port_on_tier1" "T1-DATA-SVCS-RP" {
  # description = "${nsxt_logical_router_link_port_on_tier0.T0-RP.display_name} to ${nsxt_logical_router_link_port_on_tier1.T1-RP.display_name}"
  display_name                  = "T1-DATA-SVCS-RP"
  logical_router_id             = "${nsxt_logical_tier1_router.T1-DATA-SVCS.id}"
  linked_logical_router_port_id = "${nsxt_logical_router_link_port_on_tier0.T0-DATA-SVCS-RP.id}"

  tag = {
    scope = "${var.COMP_SCOPE}"
    tag   = "${var.COMP_TAG}"
  }
}

## Create Data Services Logical Switch
resource "nsxt_logical_switch" "LS-DATA-SVCS" {
  count             = 1
  admin_state       = "UP"
  description       = "PKS mgmt provisioned by Terraform"
  display_name      = "${var.LS_DATA_SVCS_NAME}"
  transport_zone_id = "${data.nsxt_transport_zone.TZ-OVERLAY.id}"
  replication_mode  = "MTEP"

  tag = {
    scope = "${var.COMP_SCOPE}"
    tag   = "${var.COMP_TAG}"
  }
}

## Create ports on respective LS.
resource "nsxt_logical_port" "LP-DATA-SVCS" {
  count             = 1
  admin_state       = "UP"
  description       = "LP-MGMT provisioned by Terraform"
  display_name      = "${var.LP_DATA_SVCS_NAME}"
  logical_switch_id = "${nsxt_logical_switch.LS-DATA-SVCS.id}"

  tag = {
    scope = "${var.COMP_SCOPE}"
    tag   = "${var.COMP_TAG}"
  }
}

## Create Data Services LIF on Data Services T1 DLR.
resource "nsxt_logical_router_downlink_port" "DATA_SVCS_DP1" {
  count                         = 1
  description                   = "LIF-Data Services provisioned by Terraform"
  display_name                  = "LIF-DATA-SVCS"
  logical_router_id             = "${nsxt_logical_tier1_router.T1-DATA-SVCS.id}"
  linked_logical_switch_port_id = "${nsxt_logical_port.LP-DATA-SVCS.id}"
  ip_address                    = "${var.T1_DATA_SVCS_IP_NET}"

  tag = {
    scope = "${var.COMP_SCOPE}"
    tag   = "${var.COMP_TAG}"
  }
}

## Create IP Blocks

resource "nsxt_ip_block" "node_ip_block" {
  display_name = "${var.NODE_IP_BLOCK}"
  cidr         = "${var.NODE_IP_BLOCK_CIDR}"
}

resource "nsxt_ip_block" "pod_ip_block" {
  display_name = "${var.POD_IP_BLOCK}"
  cidr         = "${var.POD_IP_BLOCK_CIDR}"
}

## Create VIP Pools

resource "nsxt_ip_pool" "VIP_IP_POOL1" {
  description = "ip_pool provisioned by Terraform"
  display_name = "${var.IP_POOL_PKS_VIPS1}"

  tag = {
    scope = "${var.POOL1_SCOPE}"
    tag   = "${var.POOL1_TAG}"
  }

  subnet = {
    allocation_ranges = ["${var.VIP_IP_POOL1_RANGE}"]
    cidr              = "${var.VIP_IP_POOL1_CIDR}"
  }
}

## Output UUIDs of T0, IP Blocks, IP Pools

output "T0_ROUTER_ID" {
  value = "${nsxt_logical_tier0_router.TIER0_ROUTER.id}"
}

output "NODES_IP_BLOCK" {
  value = "${nsxt_ip_block.node_ip_block.id}"
}

output "PODS_IP_BLOCK" {
  value = "${nsxt_ip_block.pod_ip_block.id}"
}

output "VIP_IP_POOL" {
  value = "${nsxt_ip_pool.VIP_IP_POOL1.id}"
}