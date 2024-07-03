terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.35.0"
    }
  }
}

provider "google" {
  # Must define GOOGLE_PROJECT externally
  # Must define GOOGLE_REGION externally
  # Must define GOOGLE_ZONE externally

  # Default Labels
  default_labels = {
    lab_type = "cka"
  }

  add_terraform_attribution_label = true
  terraform_attribution_label_addition_strategy = "PROACTIVE"
}

resource "google_compute_network" "vpc_network" {
  name                    = "cka-lab-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_subnet" {
  name          = "cka-lab-subnet"
  network       = google_compute_network.vpc_network.name
  ip_cidr_range = var.vpc_cidr_range
}

resource "google_compute_firewall" "allow_internal" {
  name    = "allow-internal"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = [var.vpc_cidr_range]
}

resource "google_compute_firewall" "allow_gcp_iap" {
  name    = "allow-gcp-iap"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
}

resource "google_compute_instance" "vm_instance" {
  count        = length(var.instance_names)
  name         = "${var.instance_names[count.index]}"
  machine_type = var.machine_type

  boot_disk {
    initialize_params {
      image = var.machine_image_name
      size  = var.machine_size
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.vpc_subnet.name

    access_config {
      // Ephemeral public IP will be assigned to the instance
    }
  }

  service_account {
    email  = ""
    scopes = []
  }

  ## Uncomment this and create ssh key pair referenced in YAML
  ## if you intend to access the VMs remotely via SSH.

  # metadata = {
  #   user-date = file("configs/cloud-init.yaml")
  # }
}

output "vm_instance_ips" {
  value = google_compute_instance.vm_instance.*.network_interface.0.access_config.0.nat_ip
}
