#!/bin/bash

VM='Centos-68-64bit'

usage() {
  cat <<EOF
  usage: $0
  This script removes the vm created by 'create_vm.sh'.
  OPTIONS:
    -h Show this message
EOF
}

remove_vm() {
  VBoxManage unregistervm "$VM" --delete
}

main() {
  while getopts "h" option; do
    case "$option" in
      h)
        usage
        exit 0
        ;;
    esac
  done

  remove_vm
}

main "$@"
