#!/bin/bash

# Removes the port forwarding for the VM created by `create_vm.sh`

VM='Centos-68-64bit'
rule='guestssh'

VBoxManage modifyvm $VM --natpf1 delete $rule
