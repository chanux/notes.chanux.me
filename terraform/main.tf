# Setup DNS
module "dns" {
  source                   = "./modules/cloudflare"
  subdomain                = "${var.subdomain}"
  sld                      = "${var.sld}"
  tld                      = "${var.tld}"
  google_site_verification = "${var.google_site_verification}"
  cldflare_proxied         = "true"
}

# Create Google Cloud Storage Bucket for KB content
resource "google_storage_bucket" "site" {
  name          = "${var.subdomain}.${var.sld}.${var.tld}"
  storage_class = "${var.gcs_storage_class}"
  location      = "${var.gcs_location}"

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

# Public access to GCS bucket
resource "google_storage_default_object_acl" "public_access" {
  bucket      = "${google_storage_bucket.site.name}"
  role_entity = ["READER:allUsers"]
}

# Create Google Cloud Source repository for site source
resource "google_sourcerepo_repository" "site" {
  name = "${google_storage_bucket.site.name}"
}

# Create build trigger to build site upon push to git repo
resource "google_cloudbuild_trigger" "site" {
  description = "Build ${google_sourcerepo_repository.site.name} on git push"
  filename    = "${var.build_config_file_name}"

  trigger_template {
    branch_name = ".*"
    repo_name   = "${google_sourcerepo_repository.site.name}"
  }

  substitutions = {
    _GCS_BUCKET_NAME = "${google_storage_bucket.site.name}"
  }
}
