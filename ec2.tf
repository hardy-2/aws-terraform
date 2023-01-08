resource "aws_key_pair" "mykey" {
  key_name   = "mykey"
  public_key = file("mykey.pub")
}

#aws 보안그룹 설정
resource "aws_security_group" "web" {
  name   = var.instance_security_group_name
  vpc_id = aws_vpc.main.id
  ingress {
    description = "HTTP from VPC"
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#aws 공식 이미지 가져오기
data "aws_ami" "aws_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

#public 인스턴스 설정 및 생성
resource "aws_instance" "web_pub" {
  ami                         = var.image_id == "" ? data.aws_ami.aws_linux.id : var.image_id #  Amzon Linux (ap-northeast-2)
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.web.id]
  subnet_id                   = aws_subnet.pub_c.id
  user_data_replace_on_change = true
  user_data = templatefile("userdata.tftpl", {
    port_number = var.server_port
  })
  key_name = aws_key_pair.mykey.key_name
  tags = {
    Name = "tf-web-pub"
  }
}