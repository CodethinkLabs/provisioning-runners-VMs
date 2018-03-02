# Registering runners

This directory provides scripts for registering GitLab CI runners.

## Register a single runner

1. Make sure that `VM_NAME` VM is registered for the root user.
    - You may use scripts and follow instructions from
      `../runners-template-vms-creation directory` to create the template VM.
2. Register a gitlab runner for root user, based on the VM, by executing
   `sudo ./register_vm_runner.sh -n VM_NAME -u SSH_USER -p SSH_PASSWORD -r RUNNER_NAME -t REPOSITORY_TOKEN -l TAG_LIST`.
    - To unregister it, execute `sudo ./unregister_runner.sh -r RUNNER_NAME`.

## Setup pipeline runners

- `./setup-pipeline-runners.sh` is an example script that registers
  two runners for build and test stages, respectively.
- The script has the following assumptions:
    - `centos-68-build-runner` VM template is registered for root user,
      and has user `rpm_omnibus` with password `ins3cur3`.
    - `centos-68-test-runner` VM template is registered for root user,
      and has user `test` with password `ins3cur3`.
    - A correct REPOSITORY_TOKEN is provided during the script
      invocation.
