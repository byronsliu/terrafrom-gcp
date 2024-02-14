terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">4.51.0"
    }
  }
}

provider "google" {
  credentials = file("learning1-381804-54e7eb4ae9d4.json")
}

data "google_compute_zones" "my_region" {
  region  = var.region
  project = var.project_id
}

locals {
  type  = ["public", "private"]
  zones = data.google_compute_zones.my_region.names
}

# VPC
resource "google_compute_network" "my-network" {
  name                            = var.network_name
  project                         = var.project_id
  delete_default_routes_on_create = false
  auto_create_subnetworks         = false
  routing_mode                    = "REGIONAL"
}

# SUBNETS
resource "google_compute_subnetwork" "my-subnets" {
  count                    = 2
  name                     = "${var.network_name}-${local.type[count.index]}-subnetwork"
  ip_cidr_range            = var.ip_cidr_range[count.index]
  region                   = var.region
  project                  = var.project_id
  network                  = google_compute_network.my-network.id
  private_ip_google_access = true
}

# Compute Instance
resource "google_compute_instance" "webserver" {
  name         = "webserver1"
  machine_type = "n2-standard-2"
  #zone         = "${var.region}-b"
  project = var.project_id

  allow_stopping_for_update = true
  tags                      = ["stage", "dev"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "volume-1"
      }
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "NVME"
  }

  network_interface {
    network    = google_compute_network.my-network.name
    subnetwork = "${google_compute_network.my-network.name}-public-subnetwork"
  }


}

