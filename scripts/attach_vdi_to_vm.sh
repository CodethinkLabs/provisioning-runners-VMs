#!/bin/bash

# Attaches vdi created by `create_empty_vdi.sh` to the VM created by
# `create_empty_vm.sh`

VM='Centos-68-64bit'
storagename='SATA Controller'

VBoxManage storagectl $VM --name "$storagename" --add sata --controller IntelAHCI
VBoxManage storageattach $VM --storagectl "$storagename" \
  --port 0 --device 0 --type hdd --medium $VM.vdi
