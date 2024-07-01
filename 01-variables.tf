variable "instance_names" {
  description = "List of instance names"
  type = list(string)
  default = [
    "control-plane",
    "worker-node1",
    "worker-node2"
  ]
}

variable "vpc_cidr_range" {
    description = "IP CIDR range for VPC"
    type = string
    default = "192.168.200.0/24"
}

variable "machine_type" {
    description = "Compute Instance Machine Type"
    type = string
    default = "e2-medium"
}

variable "machine_image_name" {
    description = "OS Image Name for the compute instances"
    type = string
    default = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
}

variable "machine_size" {
    description = "Disk size of the compute instances"
    type = number
    default = 20
}
