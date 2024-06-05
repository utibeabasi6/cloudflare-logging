data "aws_vpc" "default" {
  default = true
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["*ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "block-device-mapping.volume-size"
    values = ["8"]
  }

  owners = ["099720109477"]

}

resource "aws_instance" "kafka" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.kafka_instance_type
  key_name      = var.key_pair
  count         = var.kafka_instance_count

  root_block_device {
    volume_type           = "gp2"
    volume_size           = var.kafka_instance_block_device_size
    delete_on_termination = "true"
  }

  metadata_options {
    http_endpoint          = "enabled"
    instance_metadata_tags = "enabled"
  }
}

resource "cloudflare_record" "kafka" {
  count   = var.kafka_instance_count
  zone_id = var.cloudflare_zone_id
  name    = "kafka${count.index}"
  value   = aws_instance.kafka[count.index].public_ip
  type    = "A"
}