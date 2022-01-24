provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "EC2-LINUX-1" {
  ami                    = "ami-05cafdf7c9f772ad2"
  instance_type          = "t2.micro"
  availability_zone      = "eu-central-1a"
  vpc_security_group_ids = [aws_security_group.web_server.id]
  user_data              = file("attach-efs-to-ec2-instances.sh")

  tags = {
    Name  = "Linux Server 1"
    Owner = "Jasson"
  }
  depends_on = [aws_efs_file_system.efs-overseers]
}

resource "aws_instance" "EC2-LINUX-2" {
  ami                    = "ami-05cafdf7c9f772ad2"
  instance_type          = "t2.micro"
  availability_zone      = "eu-central-1b"
  vpc_security_group_ids = [aws_security_group.web_server.id] #Priviazaly srazy k security group
  user_data              = file("attach-efs-to-ec2-instances.sh")

  tags = {
    Name  = "Linux Server 2"
    Owner = "Jasson"
  }
  depends_on = [aws_efs_file_system.efs-overseers]
}

resource "aws_security_group" "web_server" {
  name        = "allow_web_server"
  description = "WEB Server Ports"

  dynamic "ingress" {
    for_each = ["80", "443", "22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Web Server Security group"
    Owner = "Jasson"
  }
}

resource "aws_efs_file_system" "efs-overseers" {
  creation_token   = "Overseers"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = "true"
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name = "EFS"
  }
}

resource "aws_efs_mount_target" "efs-for-1a" {
  file_system_id  = aws_efs_file_system.efs-overseers.id
  subnet_id       = data.aws_subnet.subnet-default-1a.id
  security_groups = ["${aws_security_group.sg-for-efs.id}"]
}

resource "aws_efs_mount_target" "efs-for-1b" {
  file_system_id  = aws_efs_file_system.efs-overseers.id
  subnet_id       = data.aws_subnet.subnet-default-1b.id
  security_groups = ["${aws_security_group.sg-for-efs.id}"]
}


resource "aws_security_group" "sg-for-efs" {
  name        = "allow-connect-efs"
  description = "allow-connect-efs"

  ingress {
    description = "NFS"
    from_port   = 2049
    to_port     = 2049
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
    Name  = "sg-for-efs"
    Owner = "Jasson"
  }
}
