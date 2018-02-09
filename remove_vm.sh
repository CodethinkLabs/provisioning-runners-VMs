#!/bin/bash

# Removes the vm created by `create_vm.sh`

VM='Centos-68-64bit'

VBoxManage unregistervm $VM --delete
