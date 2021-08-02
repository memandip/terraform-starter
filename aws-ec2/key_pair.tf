resource "aws_key_pair" "aws_ec2_key_pair" {
  key_name   = "mandip_local_public_key"
  # adding my public key to ec2 instance
  public_key = file("~/.ssh/id_rsa.pub")
}
