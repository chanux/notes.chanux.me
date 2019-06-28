variable gcp_project_id {
  description = "Google cloud platform prject ID"
}

variable cloudflare_email {
  description = "Cloudflare email for API access"
}

variable cloudflare_token {
  description = "Cloudflare token for API access"
}

variable tld {
  description = "The Top Level Domain (TLD) for the site"
}

variable sld {
  description = "The second level domain (SLD) name for the site"
}

variable subdomain {
  description = "The subdomain for the site"
}

variable google_site_verification {
  description = "Random string DNS based Google ownership verification"
}

variable gcs_location {
  description = "The location for the Google Cloud Storage bucket to store site content"
  default     = "US-CENTRAL1"
}

variable gcs_storage_class {
  description = "The storage class for the Google Cloud Storage bucket to store site content"
  default     = "REGIONAL"
}

variable build_config_file_name {
  description = "Google cloud build build config file name. This file shoould be present in root of source repo to build"
  default     = "cloudbuild.yaml"
}
