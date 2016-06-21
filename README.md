# Packer Example - CentOS 7 minimal Vagrant Box using Ansible provisioner

**Current CentOS Version Used**: 7.2

This example build configuration installs and configures CentOS 7 x86_64 minimal using Ansible, and then generates three Vagrant box files, for:

  - VirtualBox
  - VMware
  - Amazon-EBS

The example can be modified to use more Ansible roles, plays, and included playbooks to fully configure (or partially) configure a box file suitable for deployment for development environments.

## Requirements

The following software must be installed/present on your local machine before you can use Packer to build the Vagrant box file:

  - [Packer](http://www.packer.io/)
  - [Vagrant](http://vagrantup.com/)
  - [VirtualBox](https://www.virtualbox.org/) (if you want to build the VirtualBox box)
  - [VMware Fusion](http://www.vmware.com/products/fusion/) (or Workstation - if you want to build the VMware box)
  - [Ansible](http://docs.ansible.com/intro_installation.html)

You will also need some Ansible roles installed so they can be used in the building of the VM. To install the roles:

  1. Run `$ ansible-galaxy install -r requirements.txt` in this directory.
  2. If your local Ansible roles path is not the default (`/etc/ansible/roles`), update the `role_paths` inside `centos7.json` to match your custom location.

If you don't have Ansible installed (perhaps you're using a Windows PC?), you can simply clone the required Ansible roles from GitHub directly (use [Ansible Galaxy](https://galaxy.ansible.com/) to get the GitHub repository URLs for each role listed in `requirements.txt`), and update the `role_paths` variable to match the location of the cloned role.


## Usage

Make sure all the required software (listed above) is installed, then cd to the directory containing this README.md file, and run:

    $ packer build -var 'aws_access_key=YOUR ACCESS KEY' -var 'aws_secret_key=YOUR SECRET KEY'  centos7.json 

After a few minutes, Packer should tell you the box was generated successfully.

If you want to only build a box for one of the supported virtualization platforms (e.g. only build the VMware box), add `--only=vmware-iso` to the `packer build` command:

    $ packer build --only=vmware-iso centos7.json

### Vagrant Amazon-EBS Box Configuration 

1. Add newly created box to vagrant.

    $ vagrant box add /path/to/aws-centos7.box --name aws-centos7

2. In your vagrant project directory you must install vagrant aws plugin. See https://github.com/mitchellh/vagrant-aws 

    $ vagrant plugin install vagrant-aws

3. Configure a Vagrantfile like one below. See https://github.com/mitchellh/vagrant-aws

```ruby 

Vagrant.configure("2") do |config|
  
  config.vm.box = "aws-centos7"

  # After issuing vagrant up command rsync will update from local folder to destination folder.
  config.vm.synced_folder "synced-folder/", "/synced-folder", type: "rsync"

  config.ssh.pty = true


  config.vm.provider :aws do |aws, override|
    
    aws.access_key_id = "ID"
    aws.secret_access_key = "SECRET"

    # This is the private AMI ID created by packer
    aws.ami = "ami-12345678"

    aws.instance_type = "t2.micro"
    
    # Assign ec2 instance a security group with port 22 open. 
    aws.security_groups = "SSH-open"

    # NFS will not work for remote instance
    override.nfs.functional = false

  end
end

```

4. After installing vagrant aws plugin to Vagrant project folder run 

    $ vagrant up --provider=aws


## License

MIT license.

## Authors Information

Created in 2014 by [Jeff Geerling](http://jeffgeerling.com/), author of [Ansible for DevOps](http://ansiblefordevops.com/).

Amazon-EBS Vagrant box build created in 2016 by [Peter Mika](peter.c.mika@gmail.com)
