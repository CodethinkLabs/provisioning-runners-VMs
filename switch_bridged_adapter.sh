#!/bin/bash

# Switches to a bridged adapter for the VM created by `create_vm.sh`

VM='Centos-68-64bit'

VBoxManage modifyvm $VM --nic1 bridged
