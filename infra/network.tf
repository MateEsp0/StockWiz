data "aws_vpc" "main" {
  id = "vpc-0b5032bc803eb71c1"
}

data "aws_subnet" "subnet_a" {
  id = "subnet-0f942cbe90338ff90"
}

data "aws_subnet" "subnet_f" {
  id = "subnet-0ab56781236ad11c0"
}

output "vpc_id" {
  value = data.aws_vpc.main.id
}

output "subnet_ids" {
  value = [
    data.aws_subnet.subnet_a.id,
    data.aws_subnet.subnet_f.id
  ]
}
