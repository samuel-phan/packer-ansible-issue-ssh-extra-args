# General

variable "aws_region" {
  description = "The AWS region to work on."
  type        = string
}

# Source AMI

variable "source_ami_most_recent" {
  description = "Selects the newest created image when `true`."
  type        = bool
  default     = true
}

variable "source_ami_owners" {
  description = "Filters the images by their owner."
  type        = list(string)
  default     = ["self"]
}

variable "source_ami_filters" {
  description = "Map of source AMI filters. See [filters here](https://www.packer.io/plugins/datasources/amazon/ami#filters)."
  # FIXME: The keyword "any" cannot be used in this type specification: an exact type is required. https://github.com/hashicorp/packer/issues/11551
  # type        = map(any)
}

# Packer instance

variable "packer_instance_type" {
  description = "The Packer instance type."
  type        = string
  default     = "t3.micro"
}

variable "packer_vpc_filters" {
  description = "Map of VPC filters. See [vpc_filter](https://www.packer.io/plugins/builders/amazon/ebs#vpc_filter)."
  # FIXME: The keyword "any" cannot be used in this type specification: an exact type is required. https://github.com/hashicorp/packer/issues/11551
  # type        = map(any)
}

variable "packer_subnet_filters" {
  description = "Map of subnet filters. See [subnet_filter](https://www.packer.io/plugins/builders/amazon/ebs#subnet_filter)."
  # FIXME: The keyword "any" cannot be used in this type specification: an exact type is required. https://github.com/hashicorp/packer/issues/11551
  # type        = map(any)
  default = {
    "tag:Network" : "Private"
  }
}

variable "packer_subnet_most_free" {
  description = "The Subnet with the most free IPv4 addresses will be used if multiple Subnets matches the filter."
  type        = bool
  default     = true
}

variable "packer_iam_instance_profile" {
  description = "The Packer IAM instance profile."
  type        = string
}

variable "packer_ssh_username" {
  description = "The username to connect to SSH with."
  type        = string
  default     = "ec2-user"
}

variable "packer_ssh_bastion_host" {
  description = "A bastion host to use for the actual SSH connection."
  type        = string
  default     = null
}

variable "packer_ssh_bastion_port" {
  description = "The port of the bastion host. Defaults to 22."
  type        = number
  default     = 22
}

variable "packer_ssh_bastion_username" {
  description = "The username to connect to the bastion host."
  type        = string
  default     = "${env("USER")}"
}

# Destination AMI

variable "destination_ami_regions" {
  description = "A list of regions to copy the AMI to."
  type        = list(string)
}

variable "destination_region_kms_key_ids" {
  description = "List of regions to copy the AMI to, along with the custom kms key id (alias or arn) to use for encryption for that region. Keys must match the regions provided in `destination_ami_regions`. Default KMS alias: `default`."
  type        = map(string)
  default     = null
}

variable "destination_ami_name" {
  description = "The destination AMI name."
  type        = string
}
