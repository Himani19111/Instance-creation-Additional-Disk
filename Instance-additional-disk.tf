provider "aws" {
  region = "ap-south-1"  # Change region as needed
}

resource "aws_instance" "my_instance" {
  ami           = "ami-0e35ddab05955cf57"  # Example AMI (use a valid one for your region)
  instance_type = "t2.micro"

  root_block_device {
    volume_size = 8  # Root disk size (optional, default is usually 8 GB)
  }

  tags = {
    Name = "Instance-With-Extra-Disk"
  }
}

# ➕ Additional EBS Volume (20GB)
resource "aws_ebs_volume" "extra_disk" {
  availability_zone = aws_instance.my_instance.availability_zone
  size              = 20  # Size in GB
  type              = "gp2"  # General Purpose SSD

  tags = {
    Name = "Extra-20GB-Disk"
  }
}

# 🔗 Attach the EBS Volume to the instance
resource "aws_volume_attachment" "ebs_attach" {
  device_name = "/dev/sdf"  # This is how Linux will see it
  volume_id   = aws_ebs_volume.extra_disk.id
  instance_id = aws_instance.my_instance.id
}
