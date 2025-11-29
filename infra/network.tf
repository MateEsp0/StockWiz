##############################################
# NETWORK CONFIG FOR LEARNER LAB (PUBLIC ONLY)
##############################################

# Import the existing VPC from Learner Lab
data "aws_vpc" "main" {
  id = "vpc-0b5032bc803eb71c1"
}

# Automatically fetch ALL public subnets in that VPC
data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

  # Only subnets where AWS assigns public IPs automatically
  filter {
    name   = "map-public-ip-on-launch"
    values = ["true"]
  }
}

