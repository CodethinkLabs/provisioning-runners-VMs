# Documentation

This repository provides scripts and instructions for:
1. Creating template VMs for build and test runners for GitLab CI
   (`./runners-template-vms-creating`).
2. Provisioning template VMs for build and test runners for GitLab CI
   (`./provisioning-runners`).
3. Registering VM runners (individual and multiple) for arbitary repository
   (`./runners-registering`).

# Setting up GitLab CI for Codethink's GCC using this repository

1. Create CentOS 6.8 VM provisioned with Omnibus
   (scripts in `./runners-template-vms-creating` might be helpful).
2. Create bare CentOS 6.8 VM
   (scripts in `./runners-template-vms-creating` might be helpful).
3. Provision the VM provisioned with Omnibus to become a template
   VM for build runners (use `./provisioning-runners` scripts).
4. Provision the bare VM to become a template VM for test runners
   (use `./provisioning-runners` scripts).
5. Register build and test runners based on the template VMs
   (use `./runners-registering` scripts)
