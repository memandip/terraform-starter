resource "aws_key_pair" "aws_ec2_key_pair" {
  key_name = "local_public_key"
  # adding my public key to ec2 instance
  # the file path is for linux or unix machine only
  public_key = file("~/.ssh/id_rsa.pub")

  tags = {
    Environment = "dev"
    Terraform   = "true"
    Type        = "public_key"
  }
}
