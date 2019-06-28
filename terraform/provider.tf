provider "google" {
  project = "${var.gcp_project_id}"
  // Set environment variable for GCP service account credentials file
  // export GOOGLE_CLOUD_KEYFILE_JSON={{path}}

  // Or set credentials file 
  // credentials = "${file("/Users/chanuka/opt/gcp/chanux-me-190621-48540fc3d6a8.json")}"
}

provider "cloudflare" {
  // Set environment variables for credentials
  // export CLOUDFLARE_EMAIL={{email}}
  // export CLOUDFLARE_TOKEN={{token}}

  // Or use variables
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
}
