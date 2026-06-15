# VPC Peering Demo
# This demo creates two VPCs in different regions and establishes peering between them

# Primary VPC in us-east-1
resource "aws_vpc" "Primary_vpc" {
  cidr_block       = var.primary_vpc_cidr
  provider = aws.primary
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "primary-vpc-${var.primary_region}"
    environment = "Demo"
    purpose = "VPC Peering-Demo"
  }
}




# Secondary VPC in ap-south-1
resource "aws_vpc" "Secondary_vpc" {
  cidr_block       = var.secondary_vpc_cidr
  provider = aws.secondary
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "secondary-vpc-${var.secondary_region}"
    environment = "Demo"
    purpose = "VPC Peering-Demo"
  }
}



resource "aws_subnet" "primary_subnet" {
    provider = aws.primary
  vpc_id     = aws_vpc.Primary_vpc.id
  cidr_block = var.primary_vpc_cidr
  availability_zone = data.aws_availability_zones.primary.names[0]
  map_public_ip_on_launch = true



  tags = {
    Name = "primary-subnet-${var.primary_region}"
    environment = "Demo"

  }
}


resource "aws_subnet" "secondary_subnet" {
    provider = aws.secondary
  vpc_id     = aws_vpc.Secondary_vpc.id
  cidr_block = var.secondary_vpc_cidr
  availability_zone = data.aws_availability_zones.secondary.names[0]
  map_public_ip_on_launch = true



  tags = {
    Name = "secondary-subnet-${var.secondary_region}"
    environment = "Demo"

  }
}


# Internet Gateway for Primary VPC
resource "aws_internet_gateway" "primary_igw" {
    provider = aws.primary  
  vpc_id = aws_vpc.Primary_vpc.id

  tags = {
    Name = "primary-igw"
    environment = "Demo"
  }
}

# Internet Gateway for Secondary VPC
resource "aws_internet_gateway" "secondary_igw" {
    provider = aws.secondary  
  vpc_id = aws_vpc.Secondary_vpc.id

  tags = {
    Name = "secondary-igw"
    environment = "Demo"
  }
}

# Route table for Primary VPC
resource "aws_route_table" "primary_route_table" {
    provider = aws.primary
  vpc_id = aws_vpc.Primary_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.primary_igw.id
  }

  tags = {
    Name = "primary-route-table"
    environment = "Demo"
  }
}

# Route table for Secondary VPC
resource "aws_route_table" "secondary_route_table" {
    provider = aws.secondary
  vpc_id = aws_vpc.Secondary_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.secondary_igw.id
  }

  tags = {
    Name = "secondary-route-table"
    environment = "Demo"
  }
}


# Associate route table with Primary subnet
resource "aws_route_table_association" "primary_route_table_association" {
    provider = aws.primary
  subnet_id      = aws_subnet.primary_subnet.id
  route_table_id = aws_route_table.primary_route_table.id
}

# Associate route table with Secondary subnet
resource "aws_route_table_association" "secondary_route_table_association" {
    provider = aws.secondary
  subnet_id      = aws_subnet.secondary_subnet.id
  route_table_id = aws_route_table.secondary_route_table.id
}


# VPC Peering Connection (Requester side - Primary VPC)

resource "aws_vpc_peering_connection" "primary_to_secondary" {
  provider = aws.primary
  vpc_id        = aws_vpc.Primary_vpc.id
  peer_vpc_id   = aws_vpc.Secondary_vpc.id
  peer_region   = var.secondary_region
  auto_accept   = false

  tags = {
    Name = "primary-to-secondary-peering"
    environment = "Demo"
    side = "Requester"
  }
}



# VPC Peering Connection Accepter (Accepter side - Secondary VPC)

resource "aws_vpc_peering_connection_accepter" "secondary_accepter" {
  provider                  = aws.secondary
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary.id
  auto_accept               = true

  tags = {
    Name = "secondary-peering-accepter"
    environment = "Demo"
    side = "Accepter"
  }
}


# Add route to Secondary VPC in Primary route table
resource "aws_route" "primary_to_secondary" {
  provider                  = aws.primary
  route_table_id            = aws_route_table.primary_route_table.id
  destination_cidr_block    = var.secondary_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary.id

  depends_on = [aws_vpc_peering_connection_accepter.secondary_accepter]
}

# Add route to Primary VPC in Secondary route table

resource "aws_route" "secondary_to_primary" {
  provider                  = aws.secondary
  route_table_id            = aws_route_table.secondary_route_table.id
  destination_cidr_block    = var.primary_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary.id

  depends_on = [aws_vpc_peering_connection_accepter.secondary_accepter]
} 

# Security Group for Primary VPC EC2 instance

resource "aws_security_group" "primary_sg" {
  provider = aws.primary
  name        = "primary-vpc-sg"
  description = "Security group for Primary VPC EC2 instance"
 vpc_id = aws_vpc.Primary_vpc.id

  ingress {
    description = "SSH access from anywhere"
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP access from Secondary VPC"
    from_port = -1
    to_port   = -1
    protocol  = "icmp"
    cidr_blocks = [var.secondary_vpc_cidr]
  }


  ingress {
    description = "allow all traffic from Secondary VPC"
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    cidr_blocks = [var.secondary_vpc_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "primary-sg"
    environment = "Demo"
  }
}


# Security Group for Secondary VPC EC2 instance
resource "aws_security_group" "secondary_sg" {
  provider = aws.secondary
  name        = "secondary-vpc-sg"
  description = "Security group for Secondary VPC EC2 instance"
  vpc_id = aws_vpc.Secondary_vpc.id

  ingress {
    description = "SSH access from anywhere"
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP access from Primary VPC"
    from_port = -1
    to_port   = -1
    protocol  = "icmp"
    cidr_blocks = [var.primary_vpc_cidr]
  }


  ingress {
    description = "allow all traffic from Primary VPC"
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    cidr_blocks = [var.primary_vpc_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "secondary-sg"
    environment = "Demo"
  }
}

# EC2 Instance in Primary VPC
resource "aws_instance" "primary_instance" {
  provider               = aws.primary
  ami                    = data.aws_ami.primary_ami.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.primary_subnet.id
  vpc_security_group_ids = [aws_security_group.primary_sg.id]
  key_name               = var.primary_key_pair_name

  user_data = local.primary_user_data

  tags = {
    Name        = "Primary-VPC-Instance"
    Environment = "Demo"
    Region      = var.primary_region
  }

  depends_on = [aws_vpc_peering_connection_accepter.secondary_accepter]
}



# EC2 Instance in Secondary VPC
resource "aws_instance" "secondary_instance" {
  provider               = aws.secondary
  ami                    = data.aws_ami.secondary_ami.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.secondary_subnet.id
  vpc_security_group_ids = [aws_security_group.secondary_sg.id]
  key_name               = var.secondary_key_pair_name

  user_data = local.secondary_user_data

  tags = {
    Name        = "Secondary-VPC-Instance"
    Environment = "Demo"
    Region      = var.secondary_region
  }

  depends_on = [aws_vpc_peering_connection_accepter.secondary_accepter]
}




