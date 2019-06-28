variable tld {
  description = "The TLD for site"
}

variable domain {
  description = "The domain name for the site"
}

variable subdomain {
  description = "The subdomain for the site"
}

variable google_site_verification {
  description = "Random string taken from Google ownership verification by DNS record"
}

resource "google_dns_managed_zone" "default" {
  name     = "${var.domain}-${var.tld}-zone"
  dns_name = "${var.domain}.${var.tld}."
}

resource "google_dns_record_set" "ownership" {
  name         = "${var.domain}.${var.tld}."
  managed_zone = "${google_dns_managed_zone.default.name}"

  rrdatas = ["google-site-verification=${var.google_site_verification}"]
  ttl     = "300"
  type    = "TXT"
}

resource "google_dns_record_set" "site" {
  name         = "${var.subdomain}.${var.domain}.${var.tld}."
  managed_zone = "${google_dns_managed_zone.default.name}"

  rrdatas = ["c.storage.googleapis.com."]
  ttl     = "300"
  type    = "CNAME"
}
