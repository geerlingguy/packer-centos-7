#!/bin/bash -eux

# Install EPEL repository.
rpm -ivh http://mirror.pnl.gov/epel/7/x86_64/e/epel-release-7-5.noarch.rpm

# Install Ansible.
yum -y install git python-setuptools gcc sudo libffi-devel python-devel openssl-devel
yum clean all
easy_install pip
pip install ansible
