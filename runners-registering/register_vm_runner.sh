#!/bin/bash

set -e

url='https://gitlab.com/'
executor='virtualbox'

usage() {
  cat <<EOF
  usage: $0 -n VM_NAME -u SSH_USER -p SSH_PASSWORD
            -r RUNNER_NAME -t REPOSITORY_TOKEN [-l TAG_LIST]

  This script registers VM named VM_NAME (with SSH_USER and SSH_PASSWORD)
  as a gitlab runner (with name RUNNER_NAME) for a repository
  with REPOSITORY TOKEN.

  OPTIONS:
  -h    Show this message
  -n    Provide a name of VM to register
  -u    Provide VM ssh user
  -p    Provide VM ssh password
  -r    Provide a name for the runner
  -t    Provide a repository token
  -l    Provide a tag list [OPTIONAL]
EOF
}

register_vm() {
  /usr/local/bin/gitlab-runner register --non-interactive \
    --url "$url" --registration-token "$repository_token" --name "$runner_name" \
    --executor "$executor" --virtualbox-base-name "$vm_name" --virtualbox-disable-snapshots \
    --ssh-user "$ssh_user" --ssh-password "$ssh_password" \
    --tag-list "$tag_list" --run-untagged "true"
}

main() {
  vm_name=""
  ssh_user=""
  ssh_password=""
  runner_name=""
  repository_token=""
  tag_list=""

  while getopts "hn:u:p:r:t:l:" option; do
    case "$option" in
      h)
        usage
        exit 0
        ;;
      n)
        vm_name="$OPTARG"
        ;;
      u)
        ssh_user="$OPTARG"
        ;;
      p)
        ssh_password="$OPTARG"
        ;;
      r)
        runner_name="$OPTARG"
        ;;
      t)
        repository_token="$OPTARG"
        ;;
      l)
        tag_list="$OPTARG"
        ;;
    esac
  done

  if [[ -z "$vm_name" ]]; then
    echo -e "ERROR: VM_NAME is mandatory\n"
    usage
    exit 1
  fi

  if [[ -z "$ssh_user" ]]; then
    echo -e "ERROR: SSH_USER is mandatory\n"
    usage
    exit 1
  fi

  if [[ -z "$ssh_password" ]]; then
    echo -e "ERROR: SSH_PASSWORD is mandatory\n"
    usage
    exit 1
  fi

  if [[ -z "$runner_name" ]]; then
    echo -e "ERROR: RUNNER_NAME is mandatory\n"
    usage
    exit 1
  fi

  if [[ -z "$repository_token" ]]; then
    echo -e "ERROR: REPOSITORY_TOKEN is mandatory\n"
    usage
    exit 1
  fi

  register_vm
}

main "$@"
