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

output "ROUTABLE_PODS_IP_BLOCK" {
  value = "${nsxt_ip_block.routeable_pod_ip_block.id}"
}

output "VIP_IP_POOL" {
  value = "${nsxt_ip_pool.VIP_IP_POOL1.id}"
}

output "SEC_VIP_IP_POOL" {
  value = "${nsxt_ip_pool.SEC_VIP_IP_POOL2.id}"
}

output "Environment Name" {
  value = "${var.ENV_NAME}"
}