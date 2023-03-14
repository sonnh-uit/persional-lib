variable "project" {
  default = "your_project_id"
}

variable "credentials_file" {
  default = "credentials.json"
}

variable "region" {
  default = "your_region"
}

variable "zone" {
  default = "your_zone"
}

variable "instances_type" {
  type = list(string)
  default = ["e2-standard-8","e2-standard-2"]

}
