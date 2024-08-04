variable "project_id" {
  description = "The ID of the project in which the resource belongs."
  type        = string
}

variable "dataset_id" {
  description = "A unique ID for this dataset, without the project name."
  type        = string
}

variable "friendly_name" {
  description = "A descriptive name for the dataset."
  type        = string
  default     = null
}

variable "description" {
  description = "A user-friendly description of the dataset."
  type        = string
  default     = null
}

variable "location" {
  description = "The geographic location where the dataset should reside."
  type        = string
  default     = "US"
}

variable "default_table_expiration_ms" {
  description = "The default lifetime of all tables in the dataset, in milliseconds."
  type        = number
  default     = null
}

variable "labels" {
  description = "A mapping of labels to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "delete_contents_on_destroy" {
  description = "If set to true, delete all the tables in the dataset when destroying the resource."
  type        = bool
  default     = false
}

variable "tables" {
  description = "A map of table names to their schemas."
  type        = map(object({
    schema = string
  }))
  default     = {}
}