#!/bin/bash -eux

# Install EPEL repository.
rpm -ivh http://mirror.pnl.gov/epel/7/x86_64/e/epel-release-7-5.noarch.rpm

# Install Ansible.
yum -y install ansible python-setuptools
