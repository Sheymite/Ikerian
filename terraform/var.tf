# Variables for flexibility
variable "region" {
  description = "AWS Region"
  default     = "eu-west-2"
}

variable "project_name" {
  description = "Project Name Prefix"
  default     = "ikerian-raw-data-pipeline"
}
