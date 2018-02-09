#!/bin/bash

usage() {
  cat <<EOF
  usage: $0 [-r]
  This script creates
    1) an empty VM with CentOS 6.8 ready to be installed, or
    2) CentOS 6.8 VM when -r parameter is applied (reuses vdi from vdis/).
  OPTIONS:
    -h Show this message
    -r Reuses a vdi that already exists.
EOF
}

create_vm() {
  echo -e "Creating an empty vm..."
  source scripts/create_empty_vm.sh

  if [[ -z "$reuse_vdi" ]];then
    echo -e "\nCreating an empty vdi..."
    source scripts/create_empty_vdi.sh
  else
    echo -e "\nCopying an existing vdi..."
    VM="Centos-68-64bit"
    cp vdis/$VM.vdi .
  fi

  echo -e "\nAttaching vdi to vm..."
  source scripts/attach_vdi_to_vm.sh

  if [[ -z "$reuse_vdi" ]];then
    echo -e "\nAttaching iso to vm..."
    source scripts/attach_iso_to_vm.sh
  fi

  echo -e "\nSetting up vm..."
  source scripts/set_up_vm.sh
}

main() {
  reuse_vdi=""

  while getopts "hr" option; do
    case $option in
      h)
        usage
	exit 0
	;;
      r)
        reuse_vdi=true
	;;
    esac
  done

  create_vm
}

main "$@"
