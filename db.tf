resource "aws_security_group" "db" {
  vpc_id = aws_vpc.main.id
  name = var.db_security_group_name
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Terraform DB subnet group"
  }
}
resource "aws_db_subnet_group" "tf-db" {
  subnet_ids = [aws_subnet.pri_a.id, aws_subnet.pri_c.id]
  name       = "tf-db"
  tags = {
    Name = "Terraform DB subnet group"
  }
}
#DB 설정
resource "aws_db_instance" "tf-db" {
  identifier_prefix      = "tf-db-"
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  db_name                = "mydb"
  username               = "hardy"
  password               = "hardy1234"
  multi_az               = true
  skip_final_snapshot    = true #DB를 지울때 자동으로 스냅샷을 찍어버린다
  db_subnet_group_name   = aws_db_subnet_group.tf-db.name
  vpc_security_group_ids = [aws_security_group.db.id]
}