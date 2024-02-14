variable "project_id" {
  type        = string
  description = "Project ID"
  default     = "Learning1"
}

variable "region" {
  type        = string
  description = "Region for this infrastructure"
  default     = "us-central1"
}

variable "network_name" {
  type        = string
  description = "Name for this infrastructure"
  default     = "my-central-vpc"
}

variable "ip_cidr_range" {
  type        = list(string)
  description = "List of The range of internal addresses that are owned by this subnetwork."
  default     = ["10.10.10.0/24", "10.10.20.0/24"]
}
