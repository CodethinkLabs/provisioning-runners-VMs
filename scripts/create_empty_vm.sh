#!/bin/bash

# Creates an empty VM

VM='Centos-68-64bit'
ostype='RedHat_64'

VBoxManage createvm --name $VM --ostype $ostype --register
