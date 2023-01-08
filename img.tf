resource "aws_ami_from_instance" "web-img" {
  name               = "terraform-webimg"
  source_instance_id = aws_instance.web_pub.id
  tags = {
    Name = "tf-ami"
  }
}