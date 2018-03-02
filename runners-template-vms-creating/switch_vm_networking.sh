#!/bin/bash

set -e

usage() {
  cat <<EOF
  usage: $0 -n VM_NAME -t nat|bridged
  This script modifies network adapter of vm named VM_NAME
  to be NAT or Bridged.
  OPTIONS:
    -h   Show this message
    -n   Provide a name for VM
    -t   Switch networking to NAT or Bridged (options: nat, bridged)
EOF
}

switch_networking() {
  case "$networking" in
    nat)
      VBoxManage modifyvm "$vm_name" --nic1 nat
      ;;
    bridged)
      VBoxManage modifyvm "$vm_name" --nic1 bridged
      ;;
    *)
      usage
      exit 1
  esac
}

main() {
  vm_name=""
  networking=""

  while getopts "hn:t:" option; do
    case "$option" in
      h)
        usage
        exit 0
        ;;
      n)
	vm_name="$OPTARG"
	;;
      t)
        networking="$OPTARG"
        ;;
    esac
  done

  if [[ -z "$vm_name" ]]; then
    echo -e "ERROR: VM_NAME is mandatory\n"
    usage
    exit 1
  fi

  if [[ ! "$networking" =~ ^(nat|bridged)$ ]]; then
    echo -e "ERROR: NETWORKING must be 'nat' or 'bridged'"
    usage
    exit 1
  fi

  switch_networking
}

main "$@"
