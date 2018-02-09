#!/bin/bash

# Creates an empty vdi with 32GB disk space (dynamic)

VM='Centos-68-64bit'

VBoxManage createhd --filename $VM.vdi --size 32768
