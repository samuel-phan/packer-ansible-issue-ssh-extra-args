packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  destination_region_kms_key_ids = coalesce(
    var.destination_region_kms_key_ids,
  { for k in var.destination_ami_regions : k => "default" })
}

data "amazon-ami" "source" {
  region = var.aws_region

  most_recent = var.source_ami_most_recent
  owners      = var.source_ami_owners

  filters = var.source_ami_filters
}

source "amazon-ebs" "packer" {
  region = var.aws_region

  ami_name      = "${var.destination_ami_name}-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  instance_type = var.packer_instance_type
  source_ami    = data.amazon-ami.source.id

  vpc_filter {
    filters = var.packer_vpc_filters
  }

  subnet_filter {
    filters   = var.packer_subnet_filters
    most_free = var.packer_subnet_most_free
  }

  iam_instance_profile = var.packer_iam_instance_profile

  communicator           = "ssh"
  ssh_username           = var.packer_ssh_username
  ssh_agent_auth         = true
  ssh_bastion_host       = var.packer_ssh_bastion_host
  ssh_bastion_port       = var.packer_ssh_bastion_port
  ssh_bastion_username   = var.packer_ssh_bastion_username
  ssh_bastion_agent_auth = true

  # AMI destinations
  ami_regions        = var.destination_ami_regions
  encrypt_boot       = true
  region_kms_key_ids = var.destination_region_kms_key_ids
}

build {
  sources = [
    "source.amazon-ebs.packer"
  ]

  provisioner "ansible" {
    playbook_file           = "${path.root}/ansible/playbook.yml"
    #inventory_file_template = "{{ .HostAlias }} ansible_host={{ .Host }} ansible_user={{ .User }} ansible_port={{ .Port }} ansible_ssh_common_args=\"-o ProxyJump=${var.packer_ssh_bastion_username}@${var.packer_ssh_bastion_host}:${var.packer_ssh_bastion_port}\"\n"
    ansible_ssh_extra_args = [
      "-o ProxyJump=${var.packer_ssh_bastion_username}@${var.packer_ssh_bastion_host}:${var.packer_ssh_bastion_port}",
    ]
    use_proxy = false
  }
}
