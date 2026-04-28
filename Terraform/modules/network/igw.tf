resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.ecommerce-vpc.id

  tags = {
    Name = "${var.environment}-igw"
  }
}
