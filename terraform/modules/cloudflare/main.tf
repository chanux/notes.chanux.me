variable "tld" {
  description = "The top level domain for the site"
}

variable "sld" {
  description = "The second level domain for the site"
}

variable "subdomain" {
  description = "The subdomain to use for the site"
}

variable "google_site_verification" {
  description = "The random string for DNS based Google site varification"
}

variable "cldflare_proxied" {
  description = "The cloudflare DNS setting to turn on off https proxy"
}

resource "cloudflare_record" "ownership" {
  domain = "${var.sld}.${var.tld}"
  name   = "${var.sld}.${var.tld}"
  value  = "google-site-verification=${var.google_site_verification}"
  type   = "TXT"
}

resource "cloudflare_record" "notes" {
  domain  = "${var.sld}.${var.tld}"
  name    = "${var.subdomain}"
  type    = "CNAME"
  value   = "c.storage.googleapis.com"
  proxied = "${var.cldflare_proxied}"
}
