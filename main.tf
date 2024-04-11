# Terraform script to create an EC2 instance with a key pair.

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = "tempkey"
  public_key = tls_private_key.pk.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.pk.private_key_pem}' > ./tempkey.pem"
  }
}

resource "aws_instance" "temp_ec2" {
  # ami           = "ami-0c7217cdde317cfec"
  # Below AMI is for Mumbai region
  ami           = var.ec2_ami_id
  instance_type = var.ec2_instance_type
  key_name      = "tempkey"


  tags = {
    Name = var.ec2_instance_name
  }

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }


  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("./${aws_key_pair.kp.key_name}.pem")
      host        = self.public_ip
    }
    source      = "cp_install.sh"
    destination = "/tmp/cp_install.sh"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("./${aws_key_pair.kp.key_name}.pem")
      host        = self.public_ip
    }
    inline = [
      "chmod +x /tmp/cp_install.sh",
      "/tmp/cp_install.sh"

    ]
  }

  vpc_security_group_ids = [aws_security_group.main.id]
}

resource "aws_security_group" "main" {
  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
  ingress = [
    {
      cidr_blocks      = ["${var.my_ip}/32"]
      description      = ""
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    },
    {
      cidr_blocks      = ["${var.my_ip}/32"]
      description      = ""
      from_port        = 6443
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 6443
    },
    {
      cidr_blocks      = ["${var.my_ip}/32"]
      description      = ""
      from_port        = 30000
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 32767
    },
    {
      cidr_blocks      = ["${var.my_ip}/32"]
      description      = ""
      from_port        = 10250
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 10250
    }
  ]
}
