#!/bin/bash

# Unregisters the runner registered by `register_runner.sh`

name='gcc_runner'

/usr/local/bin/gitlab-runner unregister -n $name
