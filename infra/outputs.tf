output "public_ip" {
  description = "Ephemeral external IP for the public demo site."
  value       = google_compute_instance.site.network_interface[0].access_config[0].nat_ip
}

output "site_url" {
  description = "Public URL of the built Astro site."
  value       = "http://${google_compute_instance.site.network_interface[0].access_config[0].nat_ip}"
}
