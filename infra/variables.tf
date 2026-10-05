variable "project_id" {
  description = "Google Cloud project that owns the existing demo VM."
  type        = string
  default     = "despliegue-prueba-510522"
}

variable "zone" {
  description = "Zone of the existing e2-micro VM."
  type        = string
  default     = "us-central1-a"
}

variable "instance_name" {
  description = "Existing VM to import and manage with this blueprint."
  type        = string
  default     = "wordpress-demo"
}

variable "repo_url" {
  description = "Public GitHub repository containing the Astro site."
  type        = string
  default     = "https://github.com/luisdlopera/astro-pagescms-vps-blueprint.git"
}
