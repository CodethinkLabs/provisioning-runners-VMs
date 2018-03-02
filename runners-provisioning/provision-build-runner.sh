#!/bin/bash

set -e

usage() {
  cat <<EOF
  usage: $0 -a VM_IP_ADDRESS

  This script configures
  [provisioned CentOS 6.8 VM](https://github.com/CodethinkLabs/provisioning-omnibus-VMs)
  described by its VM_IP_ADDRESS, to become a template for
  build gitlab CI runners.

  OPTIONS:
    -h Show this message.
    -a IP address of the VM which is going to be configured.

  EXAMPLE:
    $0 -a 192.168.256.256
EOF
}

configure_vm() {
  pushd "$script_dir"
  echo -e "Connecting to rpm_omnibus@$vm_ip_address"
  ansible-playbook -i hosts build-runner.yml \
                   -e "ansible_user=rpm_omnibus ansible_ssh_pass=1ns3cur3" \
                   -v
  ansible-playbook -i hosts gitlab-runner.yml \
                   -e "ansible_user=rpm_omnibus ansible_ssh_pass=1ns3cur3" \
                   -v
  popd
}

main() {
  script_dir="$( cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd )"
  vm_ip_address=""
  while getopts "ha:" option; do
    case $option in
      h)
        usage
        exit 0
        ;;
      a)
        vm_ip_address="$OPTARG"
        ;;
    esac
  done

  if [[ -n "$vm_ip_address" ]]; then
    echo "RUNNERVM ansible_ssh_host=$vm_ip_address" > "$script_dir/hosts"
  else
    echo -e "ERROR: VM_IP_ADDRESS is mandatory\n"
    usage
    exit 1
  fi

  configure_vm
}

main "$@"
