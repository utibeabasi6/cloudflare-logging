variable "kafka_instance_type" {
  type        = string
  description = "Instance type for kafka instances"
  default     = "t2.micro"
}

variable "kafka_instance_count" {
  type        = number
  description = "Number of kafka instances to create"
  default     = 2
}

variable "key_pair" {
  type        = string
  description = "Key pair for instances deployed"
  default     = "te"
}

variable "kafka_instance_block_device_size" {
  type        = number
  description = "Size of block device to attatch to kafka instances"
  default     = 2
}