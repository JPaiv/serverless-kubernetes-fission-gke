variable "project_id" {
  description = "The project ID to host the cluster in"
}

variable "cluster_name" {
  description = "The name for the GKE cluster"
}

variable "env_name" {
  description = "The environment for the GKE cluster"
}

variable "region" {
  description = "The region to host the cluster in"
}

variable "network" {
  description = "The VPC network created to host the cluster in"
}

variable "subnetwork" {
  description = "The subnetwork created to host the cluster in"
}

variable "ip_range_pods_name" {
  description = "The secondary ip range to use for pods"
}

variable "ip_range_services_name" {
  description = "The secondary ip range to use for services"
}

variable "subnet_ip" {
  type = string
}

variable "ip_cidr_range_pods" {
  type = string
}

variable "ip_cidr_range_services" {
  type = string
}

variable "sql_password" {
  description = "This is the sql database password. For the love of sacred cats never, ever let this be seen by the naked eye."
  type        = string
}

variable "sql_user_name" {
  description = "This is the sql database user name. For the love of sacred cats never, ever let this be seen by the naked eye."
  type        = string
}

variable "database_instance_name" {
  type = string
}

variable "database_name" {
  type = string
}
