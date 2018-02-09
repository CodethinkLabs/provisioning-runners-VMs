#!/bin/bash

# Attaches Centos iso (isos/) to VM created by `create_empty_vm.sh`

VM='Centos-68-64bit'
iso='CentOS-6.8-x86_64-minimal'
storagename='IDE Controller'

VBoxManage storagectl $VM --name "$storagename" --add ide
VBoxManage storageattach $VM --storagectl "$storagename" \
  --port 0 --device 0 --type dvddrive --medium ../isos/$iso.iso
