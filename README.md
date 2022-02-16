# Packer & Ansible plugin issue with `ansible_ssh_extra_args`

## Requirements

- AWS account access.
- have a bastion host setup.

## How to use it

Customize the values in `config/dev-us-east-1.pkrvars.hcl` (particularly for the bastion host/port/username. See the
`variables.pkr.hcl` for available variables).

Make sure you have your AWS credentials setup.

Make sure you have your SSH keys setup in your ssh-agent.

Go to the repository root directory.

```
packer init .
PACKER_LOG=1 ANSIBLE_CONFIG=$PWD/ansible/ansible.cfg packer build -var-file config/dev-us-east-1.pkrvars.hcl .
```
