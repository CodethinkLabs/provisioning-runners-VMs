#!/bin/bash

VM='Centos-68-64bit'
ostype='RedHat_64'
disk_space='32768' # MB
memory='8192'      # MB
cpus='2'
iso='CentOS-6.8-x86_64-minimal'
storage_sata='SATA Controller'
storage_ide='IDE Controller'
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

usage() {
  cat <<EOF
  usage: $0 [-r]
  This script creates
    1) an empty VM with CentOS 6.8 ready to be installed, or
    2) CentOS 6.8 VM when -r parameter is applied (reuses vdi from vdis/).
  OPTIONS:
    -h Show this message
    -r Reuses a vdi that already exists
EOF
}

create_empty_vm() {
  VBoxManage createvm --name "$VM" --ostype "$ostype" --register
}

create_empty_vdi() {
  VBoxManage createhd --filename "$script_dir/$VM".vdi --size "$disk_space"
}

copy_existing_vdi() {
  cp "$script_dir/vdis/$VM.vdi" "$script_dir"
}

attach_vdi_to_vm() {
  VBoxManage storagectl "$VM" --name "$storage_sata" --add sata \
    --controller IntelAHCI
  VBoxManage storageattach "$VM" --storagectl "$storage_sata" \
    --port 0 --device 0 --type hdd --medium "$script_dir/$VM".vdi
}

attach_iso_to_vm() {
  VBoxManage storagectl "$VM" --name "$storage_ide" --add ide
  VBoxManage storageattach "$VM" --storagectl "$storage_ide" \
    --port 0 --device 0 --type dvddrive --medium "$script_dir/isos/$iso.iso"
}

set_up_vm() {
  VBoxManage modifyvm "$VM" --ioapic on --rtcuseutc on
  VBoxManage modifyvm "$VM" --boot1 dvd --boot2 disk --boot3 none --boot4 none
  VBoxManage modifyvm "$VM" --memory "$memory" --vram 16
  VBoxManage modifyvm "$VM" --cpus "$cpus"
}

create_vm() {
  echo -e "Creating an empty vm..."
  create_empty_vm

  if [[ -z "$reuse_vdi" ]];then
    echo -e "\nCreating an empty vdi..."
    create_empty_vdi
  else
    echo -e "\nCopying an existing vdi..."
    copy_existing_vdi
  fi

  echo -e "\nAttaching vdi to vm..."
  attach_vdi_to_vm

  if [[ -z "$reuse_vdi" ]];then
    echo -e "\nAttaching iso to vm..."
    attach_iso_to_vm
  fi

  echo -e "\nSetting up vm..."
  set_up_vm
}

main() {
  reuse_vdi=""

  while getopts "hr" option; do
    case "$option" in
      h)
        usage
        exit 0
        ;;
      r)
        reuse_vdi=yes
        ;;
    esac
  done

  create_vm
}

main "$@"
