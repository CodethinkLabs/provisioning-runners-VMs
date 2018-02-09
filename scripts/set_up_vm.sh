#!/bin/bash

# Sets up VM created by `create_empty_vm.sh`

VM='Centos-68-64bit'

VBoxManage modifyvm $VM --ioapic on --rtcuseutc on
VBoxManage modifyvm $VM --boot1 dvd --boot2 disk --boot3 none --boot4 none
VBoxManage modifyvm $VM --memory 8192 --vram 16
VBoxManage modifyvm $VM --cpus 2
