# Runners provisioning

This directory provides scripts for provisioning build and test GitLab CI runner VMs
to be used for Codethink's GCC CI pipeline.

- `./provision_build_runner.sh` assumes the provided VM was previously provisioned
  with [provisioning-omnibus-VMs](https://github.com/CodethinkLabs/provisioning-omnibus-VMs).
- `./provision_test_runner.sh` expects the provided VM to be a bare CentOS 6.8.
