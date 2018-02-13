#!/bin/bash

url='https://gitlab.com/'
token='a-oX5iEQx5D5rdyA8Bxu'
name='gcc_runner'
executor='virtualbox'
VM='Centos-68-64bit'
user='rpm_omnibus'
password='1ns3cur3'

usage() {
  cat <<EOF
  usage: $0 -m value
  This script registers/unregisters $VM VM as a gitlab runner for a repository
  with token=$token.
  OPTIONS:
  -h    Show this message
  -m    Register/unregister the VM as a gitlab runner
EOF
}

register_vm() {
  /usr/local/bin/gitlab-runner register --non-interactive \
    --url "$url" --registration-token "$token" --name "$name" \
    --executor "$executor" --virtualbox-base-name "$VM" --virtualbox-disable-snapshots \
    --ssh-user "$user" --ssh-password "$password"
}

unregister_vm() {
  /usr/local/bin/gitlab-runner unregister -n "$name"
}

manage_runner() {
  case "$mode" in
    register)
      register_vm
      ;;
    unregister)
      unregister_vm
      ;;
    *)
      echo -e "Bad invocation. Possible options: register or unregister."
      usage
      exit 0
  esac
}

main() {
  mode=""

  while getopts "hm:" option; do
    case "$option" in
      h)
        usage
        exit 0
        ;;
      m)
        mode="$OPTARG"
        ;;
    esac
  done

  manage_runner
}

main "$@"
