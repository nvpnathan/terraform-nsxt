# NSX-T Terraform template for PKS Topologies

## Overview
PKS with NSX-T supports four different network architectures and deployment models. 

* [NAT](nat/README.md)
* [Routed](routed/README.md)
* [Hybrid](hybrid/README.md)
* [Multi-T0](multi-t0/README.md)

## NSX-T Networks and purpose

In each of the network architectures, PKS requires these 4 networks or supernets (IP Blocks)

### **PKS Mgmt Network**
* This Network Hosts the PKS Mgmt Components, ie Opsman, Bosh, PKS Controller, and Harbor.
* This network can be routable or non-routable depending whether you choose the NAT or Routed topology
* Minimum network size regardless of topology is /28
* **Routed Toplogy**
    - This requires a static route on your physical router pointing back to the T0 HA VIP address.
* **Hybrid Toplogy**
    - This requires a static route on your physical router pointing back to the T0 HA VIP address.
* **NAT Topology**
    - This requires DNAT rules to be applied on the T0 router. (Terraform template creates these rules)
    - The template uses 4 IP Addresses out of the VIP Pool range for Opsman, Bosh, PKS Controller, and Harbor.

### **Nodes IP Block**
* This block will be used to dynamically create a network that will host a Kubernetes Cluster Node VM's (Master(s) and Worker(s)
* Each cluster will be allocated a /24 subnet out of the block
* **Routed Toplogy**
    - This requires a static route for the IP Block (supernet) on your physical router pointing back to the T0 HA VIP address.
* **Hybrid Toplogy**
    - SNAT rules are automatically created and applied on the T0 router at the time of Kubernetes cluster creation.
* **NAT Topology**
    - SNAT rules are automatically created and applied on the T0 router at the time of Kubernetes cluster creation.
* This network block is typically a /16, as each cluster will consume a /24 out of this block

### **Pods IP Block**
* This block will be used to dynamically create a network that will host a Kubernetes Pods belonging to the same Kubernetes Namespace.
* By **default** each Kubernetes Namespaces will be allocated a /24 subnet out of the block
* By default all Kubernetes Namespaces are SNAT'd at the T0 router
* The SNAT rules are automatically created by the NSX Container Plugin (NCP) when a Kubernetes Namespaces is created.
* The Pods IP Block is typically non-routable
* Through the use of **Network-Profiles** we can change the default size of the subnet allocated to Kubernetes Namespaces as well as make a Kubernetes Namespace have corporately routable IP Address for the Pod networks
* This network block is typically a /16, as each Kubernetes Namespace by default will consume a /24 out of this block

### **VIP IP Pool**
* The VIP Pool is used for 2 purposes:
    - SNAT rules for each Kubernetes Namespace on the T0 for Pod Networking
    - LoadBalancer VIPs for the Kubernetes API and Ingress Controller created automatically at cluster creation
* This VIP Pool is **always** routable

### **Note:** Networks to avoid using for the Networks and Blocks above

* These networks by **default** are used internally by Harbor 
    * 172.18.0.0/16
    * 172.19.0.0/16
    * 172.20.0.0/16
    * 172.21.0.0/16
    * 172.22.0.0/16
* This network is used internally for Kubernetes Worker nodes
    * 172.17.0.0/16
    * 10.100.200.0/24 - Used for Kubernetes ClusterIP services so avoid this for the Nodes IP Block



