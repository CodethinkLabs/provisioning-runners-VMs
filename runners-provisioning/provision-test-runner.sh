#!/bin/bash

set -eux

usage() {
  cat <<EOF
  usage: $0 -a VM_IP_ADDRESS -p VM_ROOT_PASSWORD

  This script configures bare CentOS 6.8 VM,
  described by its VM_IP_ADDRESS, to become a template for
  test gitlab CI runners.

  OPTIONS:
    -h Show this message
    -a IP address of the VM which is going to be configured.
    -p root password of the VM which is going to be configured.

  EXAMPLE:
    $0 -a 192.168.256.256 -p insecure
EOF
}

configure_vm() {
  pushd "$script_dir"
  ansible-playbook -i hosts test-user-creation.yml \
                   -e "ansible_user=root ansible_ssh_pass=$vm_root_password"
  ansible-playbook -i hosts test-runner.yml \
                   -e "ansible_user=test ansible_ssh_pass=1ns3cur3" \
                   -v
  ansible-playbook -i hosts gitlab-runner.yml \
                   -e "ansible_user=test ansible_ssh_pass=1ns3cur3" \
                   -v
  popd
}

main() {
  script_dir="$( cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd )"
  vm_ip_address=""
  vm_root_password=""
  while getopts "ha:p:" option; do
    case $option in
      h)
        usage
        exit 0
        ;;
      a)
        vm_ip_address="$OPTARG"
        ;;
      p)
        vm_root_password="$OPTARG"
        ;;
    esac
  done

  if [[ -z "$vm_root_password" ]];then
    echo -e "ERROR: VM_ROOT_PASSWORD is mandatory\n"
    usage
    exit 1
  fi

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
