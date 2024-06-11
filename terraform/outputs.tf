output "salt_master_ip" {
  value = aws_instance.salt_master.public_ip
  description = "IP address of salt master"
}