# Creating template VMs for runners

This directory provides scripts and instructions for creating a [provisioned](https://github.com/CodethinkLabs/provisioning-omnibus-VMs)
VirtualBox CentOS 6.8 VM. The created VM is suitable for running GNU and LLVM
toolchains' Omnibus scripts (available [here](https://github.com/CodethinkLabs/omnibus-codethink-toolchain)).

# Instructions

## Create VirtualBox CentOS 6.8 VM from scratch

1. Make sure that `CentOS-6.8-x86_64-minimal.iso` is in `isos` directory.
    - It can be found [here](http://mirror.nsc.liu.se/centos-store).
2. To create a VM, execute `./create_centos6.8_vm.sh -n VM_NAME`.
    - To remove the VM, execute `./remove_vm.sh -n VM_NAME`.
3. Open VirtualBox, run the VM and proceed with CentOS 6.8 installation manually.
4. Set up networking in the VM.
    - In `ifcfg-eth0`, get rid of `HWADDR` and `UUID`.
    - Copy `ifcfg-eth0` to `ifcfg-eth5`; make sure that the content of the new
      file reflects its name.
    - In `ifcfg-eth0`, make sure there is `ONBOOT=yes` whereas in `ifcfg-eth5`
      there is `ONBOOT=no`.
    - Modify `70-persistent-net.rules` so it has one record that indicates
      `eth5`.
4. *Worth doing*: Backup vdi of bare-OS VM.
5. Provision the VM with [`provisioning-omnibus-VMs`](https://github.com/CodethinkLabs/provisioning-omnibus-VMs)
   project.
    - To make ssh connection possible, switch networking to bridged in the VM by
      executing `./switch_vm_networking.sh -n VM_NAME -t bridged`.
    - After provisioning, you may want to switch back to NAT by executing
      `./switch_vm_networking.sh -n VM_NAME -t nat`.
6. *Worth doing*: Backup vdi of provisioned VM.

## Create VirtualBox CentOS 6.8 VM based on existing vdi

- Once you got vdi of the provisioned VM with networking configured, you may want to
  backup it and create new VMs based on it. To do that:

1. Make sure that `VM_NAME.vdi` is in `vdis` directory.
2. Execute `./create_centos6.8_vm.sh -n VM_NAME -r`.

## Create VM templates for build and test GitLab CI runners

1. Make sure that `VM_BUILD_NAME.vdi` and `VM_TEST_NAME.vdi`,
   provisioned for build and test runners respectively,
   are in `vdis` directory.
2. Execute `sudo ./create_centos6.8_vm.sh -n VM_BUILD_NAME -r`.
3. Execute `sudo ./create_centos6.8_vm.sh -n VM_TEST_NAME -r`.
