output "ec2_IP" {
  value = aws_instance.aws-instance-with-terraform.public_ip
}

output "public_key" {
  value = aws_key_pair.aws_ec2_key_pair.public_key
}