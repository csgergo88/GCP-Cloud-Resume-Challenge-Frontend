variable "region" {
  default = "us-east1"
}

variable "project" {
  default = "resumechallangetest"
}

variable "cloudrunserviceurl" {
  default = "https://test-h5jqdffluq-ue.a.run.app"
}

variable "bucket_name" {
  default = "resume_challange"
}

provider "google" {
  credentials = file("credentials.json")
  project     = var.project
  region      = var.region
}

# Create Storage Bucket
resource "google_storage_bucket" "my_bucket" {
  name          = var.bucket_name
  location      = var.region
  force_destroy = true # Be cautious with this option, it will delete all objects in the bucket
}

# Update Storage Bucket Policy
resource "null_resource" "update_bucket_policy" {
  triggers = {
    bucket_name = google_storage_bucket.my_bucket.name
  }

  provisioner "local-exec" {
    command = <<-EOT
      gsutil iam ch allUsers:objectViewer gs://${google_storage_bucket.my_bucket.name}
    EOT
  }
}

# Upload HTML to Bucket
resource "google_storage_bucket_object" "html_object" {
  name   = "my_resume.html"
  source = "./my_resume.html"
  bucket = google_storage_bucket.my_bucket.name
}

# Create CDN and LB

# Create Backend Bucket
resource "google_compute_backend_bucket" "resume_backend" {
  name    = "resume-backend"
  bucket_name = google_storage_bucket.my_bucket.name
}

# Create URL Map
resource "google_compute_url_map" "cnlb" {
  name          = "cnlb"
  default_route_action {
	  weighted_backend_services {
		  backend_service = google_compute_backend_bucket.resume_backend.self_link
	  }
  }
}

# Create Target HTTP Proxy
resource "google_compute_target_http_proxy" "cnlb_target_proxy" {
  name    = "cnlb-target-proxy"
  url_map = google_compute_url_map.cnlb.self_link
}

# Create Forwarding Rule
resource "google_compute_global_forwarding_rule" "cnlb_forwarding_rule" {
  name                  = "cnlb-forwarding-rule"
  target                = google_compute_target_http_proxy.cnlb_target_proxy.self_link
  ip_protocol           = "TCP"
  port_range            = "80"
  load_balancing_scheme = "EXTERNAL_MANAGED"
#  network_tier          = "PREMIUM"
}

# Output Load Balancer IP
output "load_balancer_ip" {
  value = google_compute_global_forwarding_rule.cnlb_forwarding_rule.ip_address
}
