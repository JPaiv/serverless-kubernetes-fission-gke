locals {
  suffix = random_string.suffix.result
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "gke_auth" {
  source       = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  depends_on   = [module.gke]
  project_id   = var.project_id
  location     = module.gke.location
  cluster_name = module.gke.name
}

resource "local_file" "kubeconfig" {
  content  = module.gke_auth.kubeconfig_raw
  filename = "kubeconfig-${var.env_name}"
}

module "gcp_network" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 2.5"
  project_id   = var.project_id
  network_name = "${var.env_name}-${var.network}"
  subnets = [
    {
      subnet_name   = "${var.subnetwork}-${var.env_name}"
      subnet_ip     = var.subnet_ip
      subnet_region = var.region
    },
  ]
  secondary_ranges = {
    "${var.subnetwork}-${var.env_name}" = [
      {
        range_name    = var.ip_range_pods_name
        ip_cidr_range = var.ip_cidr_range_pods
      },
      {
        range_name    = var.ip_range_services_name
        ip_cidr_range = var.ip_cidr_range_services
      },
    ]
  }
}

module "gke" {
  source            = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  project_id        = var.project_id
  name              = "${var.env_name}-${var.cluster_name}"
  regional          = true
  region            = var.region
  network           = module.gcp_network.network_name
  subnetwork        = module.gcp_network.subnets_names[0]
  ip_range_pods     = var.ip_range_pods_name
  ip_range_services = var.ip_range_services_name
  node_pools = [
    {
      name           = "node-pool"
      machine_type   = "e2-medium"
      node_locations = "${var.region}-b,${var.region}-c,${var.region}-d"
      min_count      = 1
      max_count      = 2
      disk_size_gb   = 30
    },
  ]
}

module "database" {
  source                 = "../infra/database"
  project                = var.project_id
  sql_password           = var.sql_password
  sql_user_name          = var.sql_user_name
  database_name          = var.database_name
  database_instance_name = var.database_instance_name
  region                 = var.region
  zone                   = "${var.region}-b"
}
