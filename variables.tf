#변수를 지정
variable "image_id" {
  type    = string
  default = ""
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}
variable "server_port" {
  type    = number
  default = 80
}
variable "instance_security_group_name" {
  type    = string
  default = "allow_http_ssh_instance"
}
#DB 보안그룹 네임 변수 추가
variable "db_security_group_name" {
  type    = string
  default = "allow_mysql_db"
}

resource "aws_autoscaling_group" "web" {
  name                 = "asg-web"
  launch_configuration = aws_launch_configuration.web.name
  vpc_zone_identifier  = [aws_subnet.pri_a.id, aws_subnet.pri_c.id]

  min_size         = 2
  desired_capacity = 4
  max_size         = 10

  tag {
    key                 = "Name"
    value               = "tf-asg-web"
    propagate_at_launch = true
  }
}