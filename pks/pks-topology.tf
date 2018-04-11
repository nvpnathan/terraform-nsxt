## Connect to NSX Manager.
provider "nsxt" {
  host     = "${var.NSX_MANAGER}"
  username = "${var.NSX_USER}"
  password = "${var.NSX_PASSWORD}"
  insecure = "${var.TRUST_SSL_CERT}"
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

## Create PKS MGMT T1 Router.
resource "nsxt_logical_tier1_router" "T1-MGMT" {
  description                 = "T1 provisioned by Terraform"
  display_name                = "${var.T1_MGMT_NAME}"
  failover_mode               = "PREEMPTIVE"
  enable_router_advertisement = "true"
  advertise_connected_routes  = "true"

  tags = [{
    scope = "pks"
    tag   = "mgmt"
  }]
}

## Connect PKS MGMT T1 to T0.
resource "nsxt_logical_router_link_port_on_tier0" "T0-MGMT-RP" {
  # description = "${nsxt_logical_router_link_port_on_tier0.T0-RP.display_name} to ${nsxt_logical_router_link_port_on_tier1.T1-RP.display_name}"
  display_name      = "${var.T0_MGMT_RP}"
  logical_router_id = "${data.nsxt_logical_tier0_router.T0.id}"

  tags = [{
    scope = "pks"
    tag   = "mgmt"
  }]
}

resource "nsxt_logical_router_link_port_on_tier1" "T1-MGMT-RP" {
  # description = "${nsxt_logical_router_link_port_on_tier0.T0-RP.display_name} to ${nsxt_logical_router_link_port_on_tier1.T1-RP.display_name}"
  display_name                  = "T1-MGMT-RP"
  logical_router_id             = "${nsxt_logical_tier1_router.T1-MGMT.id}"
  linked_logical_router_port_id = "${nsxt_logical_router_link_port_on_tier0.T0-MGMT-RP.id}"

  tags = [{
    scope = "pks"
    tag   = "mgmt"
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

  tags = [{
    scope = "pks"
    tag   = "mgmt"
  }]
}

## Create ports on respective LS.
resource "nsxt_logical_port" "LP-MGMT-PKS" {
  count             = 1
  admin_state       = "UP"
  description       = "LP-MGMT provisioned by Terraform"
  display_name      = "${var.LP_MGMT_NAME}"
  logical_switch_id = "${nsxt_logical_switch.LS-MGMT-PKS.id}"

  tags = [{
    scope = "pks"
    tag   = "mgmt"
  }]
}

## Create PKS MGMT LIF on PKS T1 DLR.
resource "nsxt_logical_router_downlink_port" "MGMT_DP1" {
  count                         = 1
  description                   = "LIF-MGMT provisioned by Terraform"
  display_name                  = "LIF-MGMT"
  logical_router_id             = "${nsxt_logical_tier1_router.T1-MGMT.id}"
  linked_logical_switch_port_id = "${nsxt_logical_port.LP-MGMT-PKS.id}"

  subnets = [{
    ip_addresses = ["${var.T1_MGMT_GTWY}"]

    prefix_length = "${var.T1_MGMT_PREFIX}"
  }]

  tags = [{
    scope = "pks"
    tag   = "mgmt"
  }]
}

## Create PKS K8s Worker Nodes T1 Router.
resource "nsxt_logical_tier1_router" "T1-K8S" {
  description                 = "T1 provisioned by Terraform"
  display_name                = "${var.T1_K8S_NAME}"
  failover_mode               = "PREEMPTIVE"
  enable_router_advertisement = "true"
  advertise_connected_routes  = "true"

  tags = [{
    scope = "pks"
    tag   = "k8s"
  }]
}

## Connect PKS K8S T1 to T0.
resource "nsxt_logical_router_link_port_on_tier0" "T0-K8S-RP" {
  # description = "${nsxt_logical_router_link_port_on_tier0.T0-RP.display_name} to ${nsxt_logical_router_link_port_on_tier1.T1-RP.display_name}"
  display_name      = "${var.T0_K8S_RP}"
  logical_router_id = "${data.nsxt_logical_tier0_router.T0.id}"

  tags = [{
    scope = "pks"
    tag   = "k8s"
  }]
}

resource "nsxt_logical_router_link_port_on_tier1" "T1-K8S-RP" {
  # description = "${nsxt_logical_router_link_port_on_tier0.T0-RP.display_name} to ${nsxt_logical_router_link_port_on_tier1.T1-RP.display_name}"
  display_name                  = "T1-K8S-RP"
  logical_router_id             = "${nsxt_logical_tier1_router.T1-K8S.id}"
  linked_logical_router_port_id = "${nsxt_logical_router_link_port_on_tier0.T0-K8S-RP.id}"

  tags = [{
    scope = "pks"
    tag   = "k8s"
  }]
}

## Create PKS K8S Logical Switch
resource "nsxt_logical_switch" "LS-K8S-PKS" {
  count             = 1
  admin_state       = "UP"
  description       = "PKS mgmt provisioned by Terraform"
  display_name      = "${var.LS_K8S_NAME}"
  transport_zone_id = "${data.nsxt_transport_zone.TZ-OVERLAY.id}"
  replication_mode  = "MTEP"

  tags = [{
    scope = "pks"
    tag   = "k8s"
  }]
}

## Create ports on respective LS.
resource "nsxt_logical_port" "LP-K8S-PKS" {
  count             = 1
  admin_state       = "UP"
  description       = "LP-MGMT provisioned by Terraform"
  display_name      = "${var.LP_K8S_NAME}"
  logical_switch_id = "${nsxt_logical_switch.LS-K8S-PKS.id}"

  tags = [{
    scope = "pks"
    tag   = "k8s"
  }]
}

## Create PKS K8S LIF on PKS K8S T1 DLR.
resource "nsxt_logical_router_downlink_port" "K8S_DP1" {
  count                         = 1
  description                   = "LIF-K8S provisioned by Terraform"
  display_name                  = "LIF-K8S"
  logical_router_id             = "${nsxt_logical_tier1_router.T1-K8S.id}"
  linked_logical_switch_port_id = "${nsxt_logical_port.LP-K8S-PKS.id}"

  subnets = [{
    ip_addresses = ["${var.T1_K8S_GTWY}"]

    prefix_length = "${var.T1_K8S_PREFIX}"
  }]

  tags = [{
    scope = "pks"
    tag   = "k8s"
  }]
}
