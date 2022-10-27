/************************************************************************
Create VPC network & subnet
 ***********************************************************************/
module "create_vpc" {
  source                                 = "terraform-google-modules/network/google"
  project_id                             = local.project_id
  network_name                           = local.vpc_nm
  routing_mode                           = "REGIONAL"

  subnets = [
    {
      subnet_name           = "${local.subnet_nm}"
      subnet_ip             = "${local.subnet_cidr}"
      subnet_region         = "${local.location}"
      subnet_range          = local.subnet_cidr
      subnet_private_access = true
    }
  ]
  depends_on = [
    time_sleep.sleep_after_identities_permissions
  ]
}

/******************************************
Create Firewall rules 
 *****************************************/

resource "google_compute_firewall" "create_firewall_rule" {
  project   = local.project_id 
  name      = "allow-intra-snet-ingress-to-any"
  network   = local.vpc_nm
  direction = "INGRESS"
  source_ranges = [local.subnet_cidr]
  allow {
    protocol = "all"
  }
  description        = "Creates firewall rule to allow ingress from within subnet on all ports, all protocols"
  depends_on = [
    module.create_vpc
  ]
}

/************************************************************************
Create reserved static IP - needed for BYO network with Vertex AI workbench
 ***********************************************************************/

resource "google_compute_global_address" "create_reserved_ip" { 
  provider      = google-beta
  name          = "private-service-access-ip"
  purpose       = "VPC_PEERING"
  network       =  "projects/${local.project_id}/global/networks/${local.vpc_nm}"
  address_type  = "INTERNAL"
  prefix_length = local.psa_ip_length
  project   = local.project_id
  depends_on = [
    module.create_vpc
  ]
}

/************************************************************************
Peer the network created with Google tenant network - needed for BYO network with Vertex AI workbench
 ***********************************************************************/

resource "google_service_networking_connection" "peer_with_google_tenant_network" {
  network                 =  "projects/${local.project_id}/global/networks/${local.vpc_nm}"
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.create_reserved_ip.name]

  depends_on = [
    module.create_vpc,
    google_compute_global_address.create_reserved_ip
  ]
}

/******************************************
Create a router
*******************************************/
resource "google_compute_router" "create_nat_router" {
  name    = local.nat_router_name
  region  = "${local.location}"
  network  = local.vpc_nm

  depends_on = [
    google_compute_firewall.create_firewall_rule
  ]
}

/******************************************
Create a NAT
*******************************************/
resource "google_compute_router_nat" "create_nat" {
  name                               = "nat"
  router                             = "${google_compute_router.create_nat_router.name}"
  region                             = "${local.location}"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  depends_on = [
    google_compute_router.create_nat_router
  ]
}

/*******************************************
Introduce sleep to minimize errors from
dependencies having not completed
********************************************/
resource "time_sleep" "sleep_after_creating_network_services" {
  create_duration = "120s"
  depends_on = [
    module.create_vpc,
    google_compute_firewall.create_firewall_rule,
    google_compute_router.create_nat_router,
    google_compute_router_nat.create_nat,
    google_service_networking_connection.peer_with_google_tenant_network

  ]
}


