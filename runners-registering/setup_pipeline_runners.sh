#!/bin/bash

set -e

usage() { echo "Usage: $0 [REPOSITORY_TOKEN]" 1>&2; exit 1; }

[ $# -eq 1 ] || usage

sudo ./register_vm_runner.sh -n "centos-68-build-runner"      \
                             -u "rpm_omnibus"                 \
                             -p "1ns3cur3"                    \
                             -r "centos-68-build-runner-1"    \
                             -t "$1"                          \
                             -l "build"
sudo ./register_vm_runner.sh -n "centos-68-test-runner"       \
                             -u "test"                        \
                             -p "1ns3cur3"                    \
                             -r "centos-68-test-runner-1"     \
                             -t "$1"                          \
                             -l "test"
