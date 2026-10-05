terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0, < 8.0"
    }
  }
}

provider "google" {
  project = var.project_id
  zone    = var.zone
}

resource "google_compute_firewall" "http" {
  name    = "despliegue-wordpress-allow-http"
  network = "default"
  description = "Permitir HTTP para la demo WordPress"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["wordpress"]
}

resource "google_compute_instance" "site" {
  name         = var.instance_name
  machine_type = "e2-micro"
  zone         = var.zone
  tags         = ["wordpress"]

  boot_disk {
    auto_delete = true

    initialize_params {
      image = "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-2404-noble-amd64-v20260918"
      size  = 30
      type  = "pd-standard"
    }
  }

  network_interface {
    network    = "https://www.googleapis.com/compute/v1/projects/despliegue-prueba-510522/global/networks/default"
    subnetwork = "https://www.googleapis.com/compute/v1/projects/despliegue-prueba-510522/regions/us-central1/subnetworks/default"

    access_config {
      network_tier = "STANDARD"
    }
  }

  metadata = {
    startup-script = templatefile("${path.module}/startup.sh.tftpl", {
      repo_url = var.repo_url
    })
  }

  service_account {
    email = "221672613701-compute@developer.gserviceaccount.com"
    scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/pubsub",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
    ]
  }

  labels = {
    purpose = "cms-demo"
  }
}
