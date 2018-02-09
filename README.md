# Documentation

This repository provides scripts and instructions to create a VirtualBox CentOS
6.8 VM. The created VM is suitable to run GNU and LLVM toolchains' Omnibus scripts
(available [here](https://github.com/CodethinkLabs/omnibus-codethink-toolchain)).
It's also suitable for using as a base for gitlab CI runner. In this repository,
there are scripts and instructions to register gitlab CI runner for
[lkol's gcc](https://gitlab.com/lukasz.m.kolodziejczyk/gcc) fork of Codethink gcc.

# Instructions

## Create VirtualBox CentOS 6.8 VM from scratch

1. Make sure that `CentOS-6.8-x86_64-minimal.iso` is in `isos` directory.
    - It can be found [here](http://mirror.nsc.liu.se/centos-store).
2. To create a VM, execute `./create_vm.sh`.
    - To remove the VM, execute `./remove_vm.sh`.
3. Open VirtualBox, run the VM and proceed with CentOS 6.8 installation manually.
4. Set up networking in the VM.
    - In `ifcfg-eth0`, get rid of `HWADDR` and `UUID`.
    - Copy `ifcfg-eth0` to `ifcfg-eth5`; make sure that the content of the new
      file reflects its name.
    - In `ifcfg-eth0`, make sure there is `ONBOOT=yes` whereas in `ifcfg-eth5`
      there is `ONBOOT=no`.
    - Modify `70-persistent-net.rules` so it has one record that indicates
      `eth5`.
4. *Worth doing*: Backup vdi of only-OS VM.
5. Provision the VM with [`provisioning-omnibus-VMs`](https://github.com/CodethinkLabs/provisioning-omnibus-VMs)
   project.
    - To make ssh connection possible, switch networking to bridged in the VM by
      executing `./switch_bridged_adapter.sh`.
    - After provisioning, you may want to switch back to NAT by executing
      `./switch_nat.sh`.
6. *Worth doing*: Backup vdi of provisioned VM.

## Create VirtualBox CentOS 6.8 VM based on existing vdi

- Once you got vdi of the provisioned VM with networking tuned, you may want to
  backup it and create new VMs based on it. To do that:

1. Make sure that `CentOS-6.8-x86_64.vdi` is in `vdis` directory.
2. Execute `./create_vm.sh -r`.

## Usable scripts

1. To set up port forwarding in the VM, execute `./scripts/add_port_forwarding.sh`.
    - To remove port forwarding, execute `./scripts/remove_port_forwarding.sh`.

# Registering a gitlab runner

1. Make sure that `CentOS-6.8-x86_64` VM is registered for the root user.
    - You may follow steps from `Create VirtualBox CentOS 6.8 VM from scratch`,
      put generated vdi to `vdis` directory, then execute
      `sudo ./create_vm.sh -r`.
2. Register a gitlab runner for root user, based on the VM, by executing
   `sudo ./register_runner.sh`.
    - To unregister it, execute `sudo ./unregister_runner.sh`.
