# Create Storage Bucket
resource "google_storage_bucket" "my_bucket" {
  name          = var.bucket_name
  location      = var.region
  public_access_prevention = "inherited"
  # force_destroy = true # Be cautious with this option, it will delete all objects in the bucket
}

# Update Storage Bucket Policy
resource "google_storage_object_access_control" "public_rule" {
    object = google_storage_bucket_object.html_object.name
    bucket = google_storage_bucket.my_bucket.name
    role = "READER"
    entity = "allUsers"
}

# Upload HTML to Bucket
resource "google_storage_bucket_object" "html_object" {
  name   = "my_resume.html"
  source = "../my_resume.html"
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
  default_service = google_compute_backend_bucket.resume_backend.self_link
  name          = "cnlb"
}

# Create Target HTTP Proxy
resource "google_compute_target_http_proxy" "cnlb_target_proxy" {
  name    = "cnlb-target-proxy"
  url_map = google_compute_url_map.cnlb.self_link
}

# Output target
output "target" {
  value = google_compute_target_http_proxy.cnlb_target_proxy.self_link
}

# Create Forwarding Rule
resource "google_compute_global_forwarding_rule" "cnlb_forwarding_rule" {
#  ip_address            = google_compute_forwarding_rule.cnlb_forwarding_rule.ip_address
  name                  = "cnlb-forwarding-rule"
  target                = google_compute_target_http_proxy.cnlb_target_proxy.self_link
  ip_protocol           = "TCP"
  port_range            = "80-80"
  load_balancing_scheme = "EXTERNAL"
#  network_tier          = "PREMIUM"
}

# Output Load Balancer IP
output "load_balancer_ip" {
  value = google_compute_global_forwarding_rule.cnlb_forwarding_rule.ip_address
}
