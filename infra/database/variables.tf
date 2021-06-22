variable "project" {
  type = string
}

variable "credentials_file" {
  type = string
}

variable "region" {
  type = string
}

variable "zone" {
  type = string
}

variable "sql_password" {
  description = "This is the sql database password. For the love of sacred cats never, ever let this be seen by the naked eye."
  type        = string
}

variable "sql_user_name" {
  description = "This is the sql database user name. For the love of sacred cats never, ever let this be seen by the naked eye."
  type        = string
}

variable "database_instance_name" {
  type = string
}

variable "database_name" {
  type = string
}
