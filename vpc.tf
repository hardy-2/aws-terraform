#VPC 생성
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "tf_vpc"
  }
}

#인터넷 게이트웨이 생성
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "tf-igw"
  }
}
#퍼블릭 서브넷 생성
resource "aws_subnet" "pub_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "tf-subnet-public1-ap-northeast-2a"
  }
}

resource "aws_subnet" "pub_c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-northeast-2c"
  map_public_ip_on_launch = true
  tags = {
    Name = "tf-subnet-public1-ap-northeast-2c"
  }
}
#라우팅 테이블을 생성하고 라우트 룰을 인터넷 게이트 웨이로 설정
resource "aws_route_table" "pub" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "tf-rtb-public"
  }
}
#퍼블릭 서브넷과 라우트 테이블을 연결
resource "aws_route_table_association" "pub_a" {
  subnet_id      = aws_subnet.pub_a.id
  route_table_id = aws_route_table.pub.id
}

resource "aws_route_table_association" "pub_c" {
  subnet_id      = aws_subnet.pub_c.id
  route_table_id = aws_route_table.pub.id
}

#private 서브넷 생성
resource "aws_subnet" "pri_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    Name = "tf-subnet-private1-ap-northeast-2a"
  }
}

resource "aws_subnet" "pri_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    Name = "tf-subnet-private2-ap-northeast-2c"
  }
}
#private 라우트 테이블 생성 
#default 값으로 로컬로 연결만 가능하게 생김
resource "aws_route_table" "pri_a" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "tf-rtb-private1-ap-northeast-2a"
  }
}
resource "aws_route_table" "pri_c" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "tf-rtb-private2-ap-northeast-2c"
  }
}

#private 라우트 테이블 생성 
#default 값으로 로컬로 연결만 가능하게 생김
resource "aws_route_table" "pri_a" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "tf-rtb-private1-ap-northeast-2a"
  }
}
resource "aws_route_table" "pri_c" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "tf-rtb-private2-ap-northeast-2c"
  }
}