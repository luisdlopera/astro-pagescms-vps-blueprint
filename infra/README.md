# Google Cloud blueprint (existing VM)

This Terraform blueprint imports and manages the existing `astro-cms-demo`
Compute Engine VM in project `despliegue-prueba-510522`. It reuses that VM
instead of creating another one, then installs Apache and Node.js and builds
the Astro site from this GitHub repository. Docker is not used.

The VM is an `e2-micro` in `us-central1-a` with a 30 GB standard persistent
disk. Compute Engine's free tier has eligibility and usage limits. This
configuration assigns an ephemeral external IPv4 address so the site can be
reached publicly; that address can incur charges. The budget configured on the
project sends alerts but does not cap spending.

## Initialize and import the existing resources

Run from this directory after authenticating with `gcloud` and selecting the
project. Terraform state is local and is intentionally excluded from Git.

```sh
terraform init
terraform import google_compute_instance.site projects/despliegue-prueba-510522/zones/us-central1-a/instances/astro-cms-demo
terraform import google_compute_firewall.http projects/despliegue-prueba-510522/global/firewalls/despliegue-wordpress-allow-http
terraform plan
```

Review the plan and ensure the instance is not replaced. Apply only the
reviewed plan:

```sh
terraform apply
```

The startup script runs on the next VM boot. To start the imported VM:

```sh
gcloud compute instances start astro-cms-demo --zone=us-central1-a
```

After cloud-init finishes, read the URL from Terraform:

```sh
terraform output -raw site_url
```

## Publish edits made through Pages CMS

Pages CMS commits edits to this GitHub repository. To publish an edit on the
VM, connect using `gcloud compute ssh` and run:

```sh
sudo bash -lc 'git -C /opt/astro-blog-template pull --ff-only && cd /opt/astro-blog-template && npm ci --no-audit --no-fund && npm run build && rsync -a --delete dist/ /var/www/html/ && systemctl reload apache2'
```

The online Pages CMS panel is a separate service at https://app.pagescms.org/.
Connect it to this GitHub repository and authorize it through GitHub. Do not
place GitHub tokens or credentials in this repository.
