#!/bin/bash

set -e

usage() {
  cat <<EOF
  usage: $0 -n VM_NAME
  This script removes the vm named VM_NAME.
  OPTIONS:
    -h Show this message
    -n Provide a name for VM
EOF
}

remove_vm() {
  VBoxManage unregistervm "$vm_name" --delete
}

main() {
  vm_name=""

  while getopts "hn:" option; do
    case "$option" in
      h)
        usage
        exit 0
        ;;
      n)
	vm_name="$OPTARG"
    esac
  done

  if [[ -z $vm_name ]]; then
    echo -e "ERROR: VM_NAME is mandatory\n"
    usage
    exit 1
  fi

  remove_vm
}

main "$@"
