# Related to azure

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "swedencentral" # Change if needed
}

variable "prefix_app_name" {
  description = "Name prefix for resources"
  type        = string
  default     = "aichatbot" # Add your prefered name
}

variable "owner" {
  description = "Name of owner"
  type        = string
  default     = "Erik Unevik" # Add your own name
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

# Related to naming, taging, general 

resource "random_string" "suffix" {
  length  = 3
  special = false
  upper   = false
}

locals {
  common_tags = {
    owner = var.owner
  }
}

variable "openai_api_key" {
  description = "OpenAI API key"
  type        = string
  sensitive   = true
}

variable "websites_port" {
  type        = string
  description = "WEBSITES_PORT for the container"
  default     = "8501"
}
variable "function_app_api" {
  description = "Function App API key"
  type        = string
  sensitive   = true
}

variable "docker_image_name" {
  type        = string
  description = "Docker image name (name:tag) to run in the Web App"
  default     = "eriks-chatbot:latest" # Ad your own prefered name
}
