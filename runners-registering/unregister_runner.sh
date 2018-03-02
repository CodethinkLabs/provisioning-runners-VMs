#!/bin/bash

set -e

usage() {
  cat <<EOF
  usage: $0 -r RUNNER_NAME
  This script unregisters gitlab runner called RUNNER_NAME.
  OPTIONS:
  -h    Show this message
  -r    Provide a name of gitlab runner to unregister
EOF
}

unregister_runner() {
  /usr/local/bin/gitlab-runner unregister -n "$runner_name"
}

main() {
  runner_name=""

  while getopts "hr:" option; do
    case "$option" in
      h)
        usage
        exit 0
        ;;
      r)
        runner_name="$OPTARG"
        ;;
    esac
  done

  if [[ -z "$runner_name" ]]; then
    echo -e "ERROR: RUNNER_NAME is mandatory\n"
    usage
    exit 1
  fi

  unregister_runner
}

main "$@"
