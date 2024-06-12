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

  owners = [var.aws_account_id]

}

resource "aws_instance" "app" {
  provider = aws.app
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.app_instance_type
  key_name      = var.key_pair

  root_block_device {
    volume_type           = "gp2"
    volume_size           = var.app_instance_block_device_size
    delete_on_termination = "true"
  }

  metadata_options {
    http_endpoint          = "enabled"
    instance_metadata_tags = "enabled"
  }

  user_data = file("./scripts/install_salt_minion.sh")
  vpc_security_group_ids = [ aws_security_group.app.id ]

  tags = {
    Name = "app-${var.app_region}"
  }
}

resource "aws_instance" "salt_master" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.salt_master_instance_type
  key_name      = var.key_pair

  root_block_device {
    volume_type           = "gp2"
    volume_size           = var.salt_master_instance_block_device_size
    delete_on_termination = "true"
  }

  metadata_options {
    http_endpoint          = "enabled"
    instance_metadata_tags = "enabled"
  }

  user_data = file("./scripts/install_salt_master.sh")
  vpc_security_group_ids = [ aws_security_group.salt.id ]

  tags = {
    Name = "salt_master"
  }
}

resource "aws_instance" "kafka" {
  provider = aws.kafka
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.kafka_instance_type
  key_name      = var.key_pair

  root_block_device {
    volume_type           = "gp2"
    volume_size           = var.kafka_instance_block_device_size
    delete_on_termination = "true"
  }

  metadata_options {
    http_endpoint          = "enabled"
    instance_metadata_tags = "enabled"
  }

  tags = {
    Name = "kafka-${var.kafka_region}"
  }
}

resource "cloudflare_record" "kafka" {
  zone_id  = var.cloudflare_zone_id
  name     = "kafka-${var.kafka_region}"
  value    = aws_instance.kafka.public_ip
  type     = "A"
}

resource "cloudflare_record" "salt_master" {
  zone_id  = var.cloudflare_zone_id
  name     = "salt-master"
  value    = aws_instance.salt_master.public_ip
  type     = "A"
}

resource "aws_security_group" "salt" {
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

    ingress {
    from_port        = 4505
    to_port          = 4506
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "app" {
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

    ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}