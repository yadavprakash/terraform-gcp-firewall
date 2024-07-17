provider "google" {
  project = "testing-gcp-ops"
  region  = "asia-northeast1"
  zone    = "asia-northeast1-a"
}
#--------------------------------------------(vpc)--------------------------------------------
module "vpc" {
  source                                    = "git::git@github.com:yadavprakash/terraform-gcp-vpc.git?ref=v1.0.0"
  name                                      = "dev"
  environment                               = "test"
  label_order                               = ["name", "environment"]
  mtu                                       = 1460
  routing_mode                              = "REGIONAL"
  google_compute_network_enabled            = true
  network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"
  delete_default_routes_on_create           = false
}

#--------------------------------------------(firewall)--------------------------------------------
module "firewall" {
  source        = "./../"
  name          = "dev"
  environment   = "test"
  label_order   = ["name", "environment"]
  network       = module.vpc.vpc_id
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]

  allow = [
    { protocol = "tcp"
      ports    = ["22", "80"]
    }
  ]
}

