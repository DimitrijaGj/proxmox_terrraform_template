![debian](https://img.shields.io/badge/Debian-A81D33?style=for-the-badge&logo=debian&logoColor=white) ![linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![proxmox](https://img.shields.io/badge/Proxmox-E57000?style=for-the-badge&logo=proxmox&logoColor=white)![terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)

This is template that can be used to crete a debian trixie VMs on the Proxmox using BPG Provider
It can be used to create three sizes of machines: 
- small
- medium
- large

## Usage
‘‘‘
terraform apply -var="vm_type"
‘‘‘
