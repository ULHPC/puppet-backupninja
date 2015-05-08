-*- mode: markdown; mode: auto-fill; fill-column: 80 -*-

# Backupninja Puppet Module 

[![Puppet Forge](http://img.shields.io/puppetforge/v/ulhpc/backupninja.svg)](https://forge.puppetlabs.com/ULHPC/backupninja)
[![License](http://img.shields.io/:license-GPL3.0-blue.svg)](LICENSE)
![Supported Platforms](http://img.shields.io/badge/platform-debian|centos-lightgrey.svg)

Install and configure backupninja

      Copyright (c) 2015 UL HPC Management Team <hpc-sysadmins@uni.lu>
      

* [Online Project Page](https://github.com/ULHPC/puppet-backupninja)  -- [Sources](https://github.com/ULHPC/puppet-backupninja) -- [Issues](https://github.com/ULHPC/puppet-backupninja/issues)

## Synopsis

Install and configure backupninja
This module implements the following elements: 

* __classes__:     `backupninja`
* __definitions__: 
  * `backupninja::mydef`: 
 
The various operations of this repository are piloted from a `Rakefile` which
assumes that you have [RVM](https://rvm.io/) installed on your system.

## Dependencies

See [`metadata.json`](metadata.json). In particular, this module depends on 

* [puppetlabs/stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib)

## General Parameters

See [manifests/params.pp](manifests/params.pp)

## Overview and Usage

### class `backupninja`

     include ' backupninja'

### definition `backupninja::mydef`

The definition `backupninja::mydef` provides ...
This definition accepts the following parameters:

* `$ensure`: default to 'present', can be 'absent'
* `$content`: specify the contents of the directive as a string
* `$source`: copy a file as the content of the directive.

Example:

      backupninja::mydef {'entry':
           content => "entry\n",
      }

## Librarian-Puppet / R10K Setup

You can of course configure ULHPC-sudo in your `Puppetfile` to make it 
available with [Librarian puppet](http://librarian-puppet.com/) or
[r10k](https://github.com/adrienthebo/r10k) by adding the following entry:

     # Modules from the Puppet Forge
     mod "ulhpc-backupninja"

or, if you prefer to work on the git version: 

     mod "ulhpc-backupninja", 
         :git => https://github.com/ULHPC/puppet-backupninja,
         :ref => production 

## Issues / Feature request

You can submit bug / issues / feature request using the 
[ulhpc-backupninja Puppet Module Tracker](https://github.com/ULHPC/puppet-backupninja/issues). 


## Developments / Contributing to the code 

If you want to contribute to the code, you shall be aware of the way this module
is organized.
These elements are detailed on [`doc/contributing.md`](doc/contributing.md)

You are more than welcome to contribute to its development by 
[sending a pull request](https://help.github.com/articles/using-pull-requests). 

## Tests on Vagrant box

The best way to test this module in a non-intrusive way is to rely on
[Vagrant](http://www.vagrantup.com/). The `Vagrantfile` at the root of the
repository pilot the provisioning of the vagrant box and relies on boxes
generated through my [vagrant-vms](https://github.com/falkor/vagrant-vms)
repository.  
Once cloned, run 

      $> rake packer:Debian:init
      
To create a template. Select the version matching the once mentioned on the
`Vagrantfile` (`7.6.0-amd64` for instance)
Then run 

      $> rake packer:Debian:build
      
This shall generate the vagrant box `debian-7.6.0-amd64.box` that you can then
add to your box lists: 

      $> vagrant box add debian-7.6.0-amd64  packer/debian-7.6.0-amd64/debian-7.6.0-amd64.box

Now you can run `vagrant up` from this repository to boot the VM, provision it
to be ready to test this module (see the [`.vagrant_init.rb`](.vagrant_init.rb)
script). For instance, you can test the manifests of the `tests/` directory
within the VM: 

      $> vagrant ssh 
      [...]
      (vagrant)$> sudo puppet apply -t /vagrant/tests/init.pp
      
Run `vagrant halt` (or `vagrant destroy`) to stop (or kill) the VM once you've
finished to play with it. 

## Resources

### Git 

You should become familiar (if not yet) with Git. Consider these resources: 

* [Git book](http://book.git-scm.com/index.html)
* [Github:help](http://help.github.com/mac-set-up-git/)
* [Git reference](http://gitref.org/)
