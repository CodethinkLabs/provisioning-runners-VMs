# Documentation

This repository provides scripts and instructions for creating template VMs
for build and test runners for GitLab CI.
Here, we also provide scripts for registering the runner for [lkol's gcc](https://gitlab.com/lukasz.m.kolodziejczyk/gcc)
fork of Codethink's gcc.

# Registering a gitlab runner

1. Make sure that `CentOS-6.8-x86_64` VM is registered for the root user.
2. Register a gitlab runner for root user, based on the VM, by executing
   `sudo ./manage_runner.sh -m register`.
    - To unregister it, execute `sudo ./manage_runner.sh -m unregister`.
