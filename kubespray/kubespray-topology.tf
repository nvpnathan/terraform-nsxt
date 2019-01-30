## Connect to NSX Manager.
provider "nsxt" {
  host                 = "${var.NSX_MANAGER}"
  username             = "${var.NSX_USER}"
  password             = "${var.NSX_PASSWORD}"
  allow_unverified_ssl = "${var.TRUST_SSL_CERT}"
}

## NSX Data Collection
data "nsxt_transport_zone" "TZ-OVERLAY" {
  display_name = "${var.TZ_OVERLAY}"
}

data "nsxt_logical_tier0_router" "T0" {
  display_name = "${var.T0_RTR}"
}

data "nsxt_edge_cluster" "EDGE-CLUSTER" {
  display_name = "${var.EDGE_CLUSTER}"
}

#data "vsphere_network" "KUBE-LS" {
#    name = "${nsxt_logical_switch.LS-K8S-KUBE.display_name}"
#    datacenter_id = "${data.vsphere_datacenter.dc.id}"
#    depends_on = ["nsxt_logical_switch.LS-K8S-KUBE"]
#}

## Create Kube K8s Worker Nodes T1 Router.
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

## Connect Kube K8s T1 to T0.
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

## Create Kube K8S Logical Switch
resource "nsxt_logical_switch" "LS-K8S-KUBE" {
  count             = 1
  admin_state       = "UP"
  description       = "Kube comp provisioned by Terraform"
  display_name      = "${var.LS_K8S_NAME}"
  transport_zone_id = "${data.nsxt_transport_zone.TZ-OVERLAY.id}"
  replication_mode  = "MTEP"

  tag = {
    scope = "${var.COMP_SCOPE}"
    tag   = "${var.COMP_TAG}"
  }
}

## Create ports on respective LS.
resource "nsxt_logical_port" "LP-K8S-KUBE" {
  count             = 1
  admin_state       = "UP"
  description       = "LP-MGMT provisioned by Terraform"
  display_name      = "${var.LP_K8S_NAME}"
  logical_switch_id = "${nsxt_logical_switch.LS-K8S-KUBE.id}"

  tag = {
    scope = "${var.COMP_SCOPE}"
    tag   = "${var.COMP_TAG}"
  }
}

## Create Kube K8S LIF on Kube K8S T1 LR.
resource "nsxt_logical_router_downlink_port" "K8S_DP1" {
  count                         = 1
  description                   = "LIF-K8S provisioned by Terraform"
  display_name                  = "LIF-K8S"
  logical_router_id             = "${nsxt_logical_tier1_router.T1-K8S.id}"
  linked_logical_switch_port_id = "${nsxt_logical_port.LP-K8S-KUBE.id}"
  ip_address                    = "${var.T1_K8S_IP_NET}"

  tag = {
    scope = "${var.COMP_SCOPE}"
    tag   = "${var.COMP_TAG}"
  }
}

## Loadbalancer for API Server
resource "nsxt_logical_router_link_port_on_tier0" "T1-KUBE-RP" {
  display_name      = "${var.T0_LB_RP}"
  logical_router_id = "${data.nsxt_logical_tier0_router.T0.id}"
}

resource "nsxt_logical_tier1_router" "KUBE-LB" {
  display_name    = "${var.T1_LB_NAME}"
  edge_cluster_id = "${data.nsxt_edge_cluster.EDGE-CLUSTER.id}"
  enable_router_advertisement = true
  advertise_lb_vip_routes     = true
}

resource "nsxt_logical_router_link_port_on_tier1" "KUBE_DP1" {
  logical_router_id             = "${nsxt_logical_tier1_router.KUBE-LB.id}"
  linked_logical_router_port_id = "${nsxt_logical_router_link_port_on_tier0.T1-KUBE-RP.id}"
}

resource "nsxt_logical_switch" "LS-LB-KUBE" {
  count             = 1
  admin_state       = "UP"
  description       = "Kube comp provisioned by Terraform"
  display_name      = "${var.LS_LB_NAME}"
  transport_zone_id = "${data.nsxt_transport_zone.TZ-OVERLAY.id}"
  replication_mode  = "MTEP"

  tag = {
    scope = "${var.COMP_SCOPE}"
    tag   = "${var.API_TAG}"
  }
}

## Master NS Group - dynamic membership

resource "nsxt_ns_group" "KUBE_API_NSG" {
  description  = "NG provisioned by Terraform"
  display_name = "${var.KUBE_API_NSG}"

  membership_criteria {
    target_type = "LogicalPort"
    scope       = "kube"
    tag         = "api"
  }

  tag {
    scope = "kube-api"
    tag   = "nsg"
  }
}

resource "nsxt_logical_router_downlink_port" "LB_DP1" {
  count                         = 1
  description                   = "LIF-LB provisioned by Terraform"
  display_name                  = "LIF-LB"
  logical_router_id             = "${nsxt_logical_tier1_router.KUBE-LB.id}"
  linked_logical_switch_port_id = "${nsxt_logical_port.LP-LB-KUBE.id}"
  ip_address                    = "${var.T1_LB_IP_NET}"

  tag = {
    scope = "${var.COMP_SCOPE}"
    tag   = "${var.API_TAG}"
  }
}

resource "nsxt_logical_port" "LP-LB-KUBE" {
  count             = 1
  admin_state       = "UP"
  description       = "LP-LB provisioned by Terraform"
  display_name      = "${var.LP_K8S_NAME}"
  logical_switch_id = "${nsxt_logical_switch.LS-LB-KUBE.id}"

  tag = {
    scope = "${var.COMP_SCOPE}"
    tag   = "${var.COMP_TAG}"
  }
}

resource "nsxt_lb_service" "lb_service" {
  description  = "lb_service provisioned by Terraform"
  display_name = "${var.KUBE_LB_NAME}"

  tag = {
    scope = "${var.COMP_SCOPE}"
    tag   = "${var.API_TAG}"
  }

  enabled            = true
  logical_router_id  = "${nsxt_logical_tier1_router.KUBE-LB.id}"
  error_log_level    = "INFO"
  size               = "${var.LB_SIZE}"
  virtual_server_ids = ["${nsxt_lb_tcp_virtual_server.KUBE-API-VS.id}"]
  depends_on         = ["nsxt_logical_router_link_port_on_tier1.KUBE_DP1"]
}

resource "nsxt_lb_fast_tcp_application_profile" "timeout_60" {
  close_timeout = 60
  idle_timeout  = 60
}

resource "nsxt_lb_source_ip_persistence_profile" "ip_profile" {
  display_name = "source1"
}

resource "nsxt_lb_pool" "KUBE-API-POOL" {
  algorithm = "${var.LB_ALGORITHM}"
  snat_translation {
    type          = "SNAT_AUTO_MAP"
    port_overload = "32"
  }

  member_group {
    ip_version_filter   = "IPV4"
    limit_ip_list_size  = true
    max_ip_list_size    = "3"
    port                = "6443"

    grouping_object {
      target_type = "NSGroup"
      target_id   = "${nsxt_ns_group.KUBE_API_NSG.id}"
      }
    }  
}

resource "nsxt_lb_tcp_virtual_server" "KUBE-API-VS" {
  description                = "lb_virtual_server provisioned by terraform"
  display_name               = "${var.KUBE_VS_NAME}"
  access_log_enabled         = true
  application_profile_id     = "${nsxt_lb_fast_tcp_application_profile.timeout_60.id}"
  enabled                    = true
  ip_address                 = "${var.KUBE_VIP}"
  ports                      = ["${var.KUBE_API_PORT}"]
  default_pool_member_ports  = ["${var.KUBE_API_PORT}"]
  max_concurrent_connections = 50
  max_new_connection_rate    = 20
  persistence_profile_id     = "${nsxt_lb_source_ip_persistence_profile.ip_profile.id}"
  pool_id                    = "${nsxt_lb_pool.KUBE-API-POOL.id}"

  tag {
    scope = "${var.COMP_SCOPE}"
    tag   = "${var.API_TAG}"
  }
}
