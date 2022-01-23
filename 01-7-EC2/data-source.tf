data "aws_vpc" "vpc-default" {
  tags = {
    Name = "Default"
  }
}
data "aws_subnet" "subnet-default-1a" {
  tags = {
    Name = "1a"
  }
}
data "aws_subnet" "subnet-default-1b" {
  tags = {
    Name = "1b"
  }
}
data "aws_subnet" "subnet-default-1c" {
  tags = {
    Name = "1c"
  }
}
output "defaul-vpc" {
  value = data.aws_vpc.vpc-default.id
}
output "defaul-subnet-1a" {
  value = data.aws_subnet.subnet-default-1a.id
}
output "defaul-subnet-1b" {
  value = data.aws_subnet.subnet-default-1b.id
}
output "defaul-subnet-1c" {
  value = data.aws_subnet.subnet-default-1c.id
}
