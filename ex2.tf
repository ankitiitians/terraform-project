# 1) Key pair for EC2 login
resource "aws_key_pair" "my_key" {
  key_name   = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
}

# 2) Default VPC
resource "aws_default_vpc" "default" {}

# 3) Security group
resource "aws_security_group" "my_security_group" {
  name        = "automate-sg"
  description = "Terraform security group, allow SSH/HTTP/8000"
  vpc_id      = aws_default_vpc.default.id

  tags = {
    Name = "automate-sg"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
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

# 4) EC2 instance
resource "aws_instance" "my_instance" {
  for_each = tomap({
    "instance1-micro" = "t2.micro" ,
    "instance2-medium" = "t2.small" ,
    "instance3-large" = "t2.small"
    
  
  })

  depends_on = [ aws_security_group.my_security_group, aws_key_pair.my_key]

  #count = 3 # it is a meta argument- jitne likh do ge utna instance create ho jayenge
  key_name = aws_key_pair.my_key.key_name

  vpc_security_group_ids = [
    aws_security_group.my_security_group.id
  ]

  ami           = var.ec2_ami_id
  instance_type = each.value

# root_block_device ka matlab hota hai EC2 instance ka main (root) storage configure karna,
# yani jo primary disk hoti hai jisme OS (Linux/Windows) install hota hai.

  root_block_device {
  # Agar env = "prod" hai → storage double
  # warna normal/default size

    volume_size =  var.environment == "prod" ? var.ec2_default_root_storage_size * 2 : var.ec2_default_root_storage_size
    volume_type = "gp3"

  }

  tags = {
    Name = each.key
  }
}

resource "aws_instance" "new" {
  # depends_on = [aws_security_group.my_security_group, aws_key_pair.my_key]

  ami           = "ami-014d82945a82dfba3"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.my_key.key_name
}