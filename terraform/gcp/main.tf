terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project
  region      = var.region
  zone        = var.zone
}


resource "google_compute_instance" "default" {
  for_each = toset(var.instances_type)
  name         = "server-${each.value}"
  machine_type = each.value
  zone         = var.zone
  tags = ["your_tags"]

  boot_disk {
    initialize_params {
      size  = 100
      type = "pd-ssd"
      image = "centos-cloud/centos-7"

    }
}

  scheduling {
    preemptible = true
    automatic_restart = false
    on_host_maintenance = "TERMINATE"
    # provisioning_model = "SPOT"

  }
  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }
  metadata_startup_script = file("startup-script")
}

