#!/bin/bash

VM='Centos-68-64bit'

usage() {
  cat <<EOF
  usage: $0 -n value
  This script modifies $VM network adapter to be NAT or Bridged.
  OPTIONS:
    -h   Show this message
    -n   Switch networking to NAT or Bridged (options: nat, bridged)
EOF
}

switch_networking() {
  case "$networking" in
    nat)
      VBoxManage modifyvm "$VM" --nic1 nat
      ;;
    bridged)
      VBoxManage modifyvm "$VM" --nic1 bridged
      ;;
    *)
      echo -e "Unknown argument passed. Possible options: nat or bridged."
      usage
      exit 0
  esac
}

main() {
  networking=""

  while getopts "hn:" option; do
    case "$option" in
      h)
        usage
        exit 0
        ;;
      n)
        networking="$OPTARG"
        ;;
    esac
  done

  switch_networking
}

main "$@"
