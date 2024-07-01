### Uncomment this block and set appropriate IP address
### range if you wish to access the resources created
### via public internet.
###   NOTE: You might consider uncommenting the "metadata"
###   block in the compute_instance as well.

# resource "google_compute_firewall" "allow_external" {
#   name    = "allow-external"
#   network = google_compute_network.vpc_network.name

#   allow {
#     protocol = "tcp"
#     ports    = ["22", "80", "443"]
#   }

#   source_ranges = ["0.0.0.0/0"]
# }
