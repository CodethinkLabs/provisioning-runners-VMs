#!/bin/bash

# Registers a VM created by `create_vm.sh` as gitlab ci runner

url='https://gitlab.com/'
token='a-oX5iEQx5D5rdyA8Bxu'
name='gcc_runner'
executor='virtualbox'
VM='Centos-68-64bit'
user='rpm_omnibus'
password='1ns3cur3'

/usr/local/bin/gitlab-runner register --non-interactive \
  --url $url --registration-token $token --name $name \
  --executor $executor --virtualbox-base-name $VM --virtualbox-disable-snapshots \
  --ssh-user $user --ssh-password $password
