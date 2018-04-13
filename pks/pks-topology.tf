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

data "nsxt_logical_tier0_router" "T0" {
  display_name = "${var.T0_RTR}"
}

data "nsxt_edge_cluster" "EDGE-CLUSTER" {
  display_name = "${var.EDGE_CLUSTER}"
}

## Create MGMT and Compute SNAT Rules
resource "nsxt_nat_rule" "rule1" {
  logical_router_id    = "${data.nsxt_logical_tier0_router.T0.id}"
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

resource "nsxt_nat_rule" "rule2" {
  logical_router_id    = "${data.nsxt_logical_tier0_router.T0.id}"
  description          = "PKS COMPUTE SNAT provisioned by Terraform"
  display_name         = "${var.COMP_SNAT}"
  action               = "SNAT"
  enabled              = true
  logging              = false
  nat_pass             = true
  translated_network   = "${var.COMP_TNET}"
  match_source_network = "${var.COMP_SOURCE}"

  tag {
    scope = "${var.COMP_SCOPE}"
    tag   = "${var.COMP_TAG}"
  }
}

## Create MGMT DNAT Rules
resource "nsxt_nat_rule" "rule3" {
  logical_router_id         = "${data.nsxt_logical_tier0_router.T0.id}"
  description               = "PKS Ops-Man DNAT provisioned by Terraform"
  display_name              = "${var.OPS_MAN_DNAT}"
  action                    = "DNAT"
  enabled                   = true
  logging                   = false
  nat_pass                  = true
  translated_network        = "${var.OPS_MAN_TIP}"
  match_destination_network = "${var.OPS_MAN_DIP}"

  tag {
    scope = "${var.MGMT_SCOPE}"
    tag   = "${var.MGMT_TAG}"
  }
}

resource "nsxt_nat_rule" "rule4" {
  logical_router_id         = "${data.nsxt_logical_tier0_router.T0.id}"
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

resource "nsxt_nat_rule" "rule5" {
  logical_router_id         = "${data.nsxt_logical_tier0_router.T0.id}"
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

resource "nsxt_nat_rule" "rule6" {
  logical_router_id         = "${data.nsxt_logical_tier0_router.T0.id}"
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
  failover_mode               = "PREEMPTIVE"
  enable_router_advertisement = "true"
  advertise_connected_routes  = "true"

  tag = [{
    scope = "${var.MGMT_SCOPE}"
    tag   = "${var.MGMT_TAG}"
  }]
}

## Connect PKS MGMT T1 to T0.
resource "nsxt_logical_router_link_port_on_tier0" "T0-MGMT-RP" {
  # description = "${nsxt_logical_router_link_port_on_tier0.T0-RP.display_name} to ${nsxt_logical_router_link_port_on_tier1.T1-RP.display_name}"
  display_name      = "${var.T0_MGMT_RP}"
  logical_router_id = "${data.nsxt_logical_tier0_router.T0.id}"

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

## Create PKS K8s Worker Nodes T1 Router.
resource "nsxt_logical_tier1_router" "T1-K8S" {
  description                 = "T1 provisioned by Terraform"
  display_name                = "${var.T1_K8S_NAME}"
  failover_mode               = "PREEMPTIVE"
  enable_router_advertisement = "true"
  advertise_connected_routes  = "true"

  tag = {
    scope = "${var.COMP_SCOPE}"
    tag   = "${var.COMP_TAG}"
  }
}

## Connect PKS K8S T1 to T0.
resource "nsxt_logical_router_link_port_on_tier0" "T0-K8S-RP" {
  # description = "${nsxt_logical_router_link_port_on_tier0.T0-RP.display_name} to ${nsxt_logical_router_link_port_on_tier1.T1-RP.display_name}"
  display_name      = "${var.T0_K8S_RP}"
  logical_router_id = "${data.nsxt_logical_tier0_router.T0.id}"

  tag = {
    scope = "${var.COMP_SCOPE}"
    tag   = "${var.COMP_TAG}"
  }
}

resource "nsxt_logical_router_link_port_on_tier1" "T1-K8S-RP" {
  # description = "${nsxt_logical_router_link_port_on_tier0.T0-RP.display_name} to ${nsxt_logical_router_link_port_on_tier1.T1-RP.display_name}"
  display_name                  = "T1-K8S-RP"
  logical_router_id             = "${nsxt_logical_tier1_router.T1-K8S.id}"
  linked_logical_router_port_id = "${nsxt_logical_router_link_port_on_tier0.T0-K8S-RP.id}"

  tag = {
    scope = "${var.COMP_SCOPE}"
    tag   = "${var.COMP_TAG}"
  }
}

## Create PKS K8S Logical Switch
resource "nsxt_logical_switch" "LS-K8S-PKS" {
  count             = 1
  admin_state       = "UP"
  description       = "PKS mgmt provisioned by Terraform"
  display_name      = "${var.LS_K8S_NAME}"
  transport_zone_id = "${data.nsxt_transport_zone.TZ-OVERLAY.id}"
  replication_mode  = "MTEP"

  tag = {
    scope = "${var.COMP_SCOPE}"
    tag   = "${var.COMP_TAG}"
  }
}

## Create ports on respective LS.
resource "nsxt_logical_port" "LP-K8S-PKS" {
  count             = 1
  admin_state       = "UP"
  description       = "LP-MGMT provisioned by Terraform"
  display_name      = "${var.LP_K8S_NAME}"
  logical_switch_id = "${nsxt_logical_switch.LS-K8S-PKS.id}"

  tag = {
    scope = "${var.COMP_SCOPE}"
    tag   = "${var.COMP_TAG}"
  }
}

## Create PKS K8S LIF on PKS K8S T1 DLR.
resource "nsxt_logical_router_downlink_port" "K8S_DP1" {
  count                         = 1
  description                   = "LIF-K8S provisioned by Terraform"
  display_name                  = "LIF-K8S"
  logical_router_id             = "${nsxt_logical_tier1_router.T1-K8S.id}"
  linked_logical_switch_port_id = "${nsxt_logical_port.LP-K8S-PKS.id}"
  ip_address                    = "${var.T1_K8S_IP_NET}"

  tag = {
    scope = "${var.COMP_SCOPE}"
    tag   = "${var.COMP_TAG}"
  }
}
