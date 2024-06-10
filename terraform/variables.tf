variable "kafka_instance_type" {
  type        = string
  description = "Instance type for kafka instances"
  default     = "t2.micro"
}

variable "key_pair" {
  type        = string
  description = "Key pair for instances deployed"
}

variable "kafka_instance_block_device_size" {
  type        = number
  description = "Size of block device to attatch to kafka instances"
  default     = 8
}

variable "cloudflare_zone_id" {
  type        = string
  description = "Zone id of cloudflare domain"
}

variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API token"
}

variable "app_instance_type" {
  type        = string
  description = "Instance type for app instances"
  default     = "t2.micro"
}

variable "app_instance_block_device_size" {
  type        = number
  description = "Size of block device to attatch to app instances"
  default     = 8
}

variable "aws_account_id" {
    type = string
    description = "AWS account id"
    default = "099720109477"
}

variable "kafka_region" {
  type = string
  description = "Region to deploy kafka instance into"
  default = "us-east-1"
}

variable "app_region" {
  type = string
  description = "Region to deploy app instance into"
  default = "us-east-1"
}

variable "salt_master_instance_type" {
  type        = string
  description = "Instance type for salt master instance"
  default     = "t2.micro"
}

variable "salt_master_instance_block_device_size" {
  type        = number
  description = "Size of block device to attatch to the salt master instance"
  default     = 8
}