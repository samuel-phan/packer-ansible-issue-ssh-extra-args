# General

aws_region = "us-east-1"

# Source

source_ami_filters = {
  name = "centos-7-*"
}

# Packer

packer_vpc_filters          = {
  "tag:Name" : "my-vpc"
}
packer_iam_instance_profile = "my-ec2-instance-profile"

packer_ssh_bastion_host     = "bastion.my-company.com"
packer_ssh_bastion_username = "me"

# Destination

destination_ami_regions = [
  "us-east-1",
]
destination_ami_name    = "test-packer"
