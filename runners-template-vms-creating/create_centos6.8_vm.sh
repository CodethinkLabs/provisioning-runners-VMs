#!/bin/bash

set -e

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
  usage: $0 -n VM_NAME [-r]
  This script creates
    1) an empty VM with CentOS 6.8 ready to be installed, or
    2) CentOS 6.8 VM when -r parameter is applied
       (reuses vdi named VM_NAME located in SCRIPT_DIR/vdis).
  OPTIONS:
    -h Show this message
    -n Provide a name for VM
    -r Reuses a vdi that already exists
EOF
}

create_empty_vm() {
  VBoxManage createvm --name "$vm_name" --ostype "$ostype" --register

  local vm_info="$(VBoxManage showvminfo "$vm_name")"
  local vm_config_line="$(echo -e "$vm_info" | grep "Config file:")"
  local vm_config_path="$(echo -e "$vm_config_line" | sed "s/Config file: *//")"
  vdi_dir="$(dirname "$vm_config_path")"
}

create_empty_vdi() {
  VBoxManage createhd --filename "$vdi_dir/$vm_name.vdi" --size "$disk_space"
}

copy_existing_vdi() {
  cp "$script_dir/vdis/$vm_name.vdi" "$vdi_dir"
  VBoxManage internalcommands sethduuid "$vdi_dir/$vm_name.vdi"
}

attach_vdi_to_vm() {
  VBoxManage storagectl "$vm_name" --name "$storage_sata" --add sata \
    --controller IntelAHCI
  VBoxManage storageattach "$vm_name" --storagectl "$storage_sata" \
    --port 0 --device 0 --type hdd --medium "$vdi_dir/$vm_name".vdi
}

attach_iso_to_vm() {
  VBoxManage storagectl "$vm_name" --name "$storage_ide" --add ide
  VBoxManage storageattach "$vm_name" --storagectl "$storage_ide" \
    --port 0 --device 0 --type dvddrive --medium "$script_dir/isos/$iso.iso"
}

set_up_vm() {
  VBoxManage modifyvm "$vm_name" --ioapic on --rtcuseutc on
  VBoxManage modifyvm "$vm_name" --boot1 dvd --boot2 disk --boot3 none --boot4 none
  VBoxManage modifyvm "$vm_name" --memory "$memory" --vram 16
  VBoxManage modifyvm "$vm_name" --cpus "$cpus"
}

create_vm() {
  echo -e "\n- Creating an empty vm..."
  create_empty_vm

  if [[ -z "$reuse_vdi" ]]; then
    echo -e "\n- Creating an empty vdi in '$vdi_dir'..."
    create_empty_vdi
  else
    echo -e "\n- Copying an existing vdi to '$vdi_dir'..."
    copy_existing_vdi
  fi

  echo -e "\n- Attaching vdi to vm..."
  attach_vdi_to_vm

  if [[ -z "$reuse_vdi" ]]; then
    echo -e "\n- Attaching iso to vm..."
    attach_iso_to_vm
  fi

  echo -e "\n- Setting up vm...\n"
  set_up_vm
}

main() {
  vm_name=""
  reuse_vdi=""

  while getopts "hn:r" option; do
    case "$option" in
      h)
        usage
        exit 0
        ;;
      n)
        vm_name="$OPTARG"
        ;;
      r)
        reuse_vdi=yes
        ;;
    esac
  done

  if [[ -z "$vm_name" ]]; then
    echo -e "ERROR: VM_NAME is mandatory\n"
    usage
    exit 1
  fi

  create_vm
}

main "$@"
