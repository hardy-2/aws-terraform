#이미지 수정과 DB 정보 추가
resource "aws_launch_configuration" "web" {
  name_prefix     = "lc-web-"
  image_id        = "ami-04bff6797b0c74d59"
  instance_type   = var.instance_type
  security_groups = [aws_security_group.web.id]
  user_data = templatefile("userdata2.tftpl", {
    port_number = var.server_port
    db_endpoint = aws_db_instance.tf-db.endpoint
  })
  key_name = aws_key_pair.mykey.key_name
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_db_instance.tf-db]
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

resource "aws_autoscaling_group" "web" {
  name                 = "asg-web"
  launch_configuration = aws_launch_configuration.web.name
  vpc_zone_identifier  = [aws_subnet.pri_a.id, aws_subnet.pri_c.id]

  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"

  min_size         = 2
  desired_capacity = 4
  max_size         = 10

  tag {
    key                 = "Name"
    value               = "tf-asg-web"
    propagate_at_launch = true
  }
}