-*- mode: markdown; mode: visual-line;  -*-

# Backupninja Puppet Module 

[![Puppet Forge](http://img.shields.io/puppetforge/v/ulhpc/backupninja.svg)](https://forge.puppetlabs.com/ULHPC/backupninja)
[![License](http://img.shields.io/:license-GPL3.0-blue.svg)](LICENSE)
![Supported Platforms](http://img.shields.io/badge/platform-debian|centos-lightgrey.svg)

Install and configure backupninja

      Copyright (c) 2015 UL HPC Management Team <hpc-sysadmins@uni.lu>
      

* [Online Project Page](https://github.com/ULHPC/puppet-backupninja)  -- [Sources](https://github.com/ULHPC/puppet-backupninja) -- [Issues](https://github.com/ULHPC/puppet-backupninja/issues)

## Synopsis

Install and configure backupninja.

This module implements the following elements: 

* __Puppet classes__:
    - `backupninja` 
    - `backupninja::common` 
    - `backupninja::common::debian` 
    - `backupninja::common::redhat` 
    - `backupninja::params` 

* __Puppet definitions__: 
    - `backupninja::distantlvm` 
    - `backupninja::ldap` 
    - `backupninja::mysql` 
    - `backupninja::pgsql` 
    - `backupninja::rsync` 

All these components are configured through a set of variables you will find in
[`manifests/params.pp`](manifests/params.pp). 

_Note_: the various operations that can be conducted from this repository are piloted from a [`Rakefile`](https://github.com/ruby/rake) and assumes you have a running [Ruby](https://www.ruby-lang.org/en/) installation.
See [`doc/contributing.md`](doc/contributing.md) for more details on the steps you shall follow to have this `Rakefile` working properly. 

## Dependencies

See [`metadata.json`](metadata.json). In particular, this module depends on 

* [puppetlabs/stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib)

## Overview and Usage

### Class `backupninja`

This is the main class defined in this module.
It accepts the following parameters: 

* `$ensure`: default to 'present', can be 'absent'

Use is as follows:

     include ' backupninja'

See also [`tests/init.pp`](tests/init.pp)

### Class `backupninja::common`

See [`tests/common.pp`](tests/common.pp)

### Class `backupninja::common::debian`

See [`tests/common/debian.pp`](tests/common/debian.pp)

### Class `backupninja::common::redhat`

See [`tests/common/redhat.pp`](tests/common/redhat.pp)

### Class `backupninja::params`

See [`tests/params.pp`](tests/params.pp)

### Definition `backupninja::distantlvm`

The definition `backupninja::distantlvm` provides a way to configure our own `distantlvm`
backup action. It creates LVM logical volume snapshot, and retrieves them via ssh. 
It is of your responsibility to set-up sudo and authorize ssh connections from 
the backup server to the remote server. 

This definition accepts the following parameters:

* `$ensure`: default to 'present', can be 'absent'
* `$vg`: lvm volume group name on the remote server
* `$lv`: space separated list of logical volumes to be backed up
* `$backupdir`: backup target directory (local)
* `$ssh_host`: remote server hostname
* `$ssh_user`: remote ssh server user
* `$ssh_port`: remote ssh server port
* `$when`: execution time, using backupninja format
* `$keep`: if specified, keep the last $keep backups

Example:


    backupninja::distantlvm { "backup_dom0_${name}":
        ensure     => 'present',
        backupdir  => '/data/backup_dom0',
        ssh_host   => 'dom0-server.uni.lu',
        ssh_user   => 'localuser',
        ssh_port   => '22',
        vg         => vg_domU,
        lv         => 'domu1-disk domu2-disk domu3-disk',
        keep       => 5,
        when       => 'mondays at 03:00'
    }


### Definitions `backupninja::ldap`, `backupninja::rsync`, `backupninja::pgsql`, `backupninja::mysql`

These definitions implements the standard handlers provided by backupninja.
All the parameters are derived from the handlers and are documented [online](https://labs.riseup.net/code/projects/backupninja)


## Librarian-Puppet / R10K Setup

You can of course configure the backupninja module in your `Puppetfile` to make it available with [Librarian puppet](http://librarian-puppet.com/) or
[r10k](https://github.com/adrienthebo/r10k) by adding the following entry:

     # Modules from the Puppet Forge
     mod "ulhpc-backupninja"

or, if you prefer to work on the git version: 

     mod "ulhpc-backupninja", 
         :git => https://github.com/ULHPC/puppet-backupninja,
         :ref => production 

## Issues / Feature request

You can submit bug / issues / feature request using the [ulhpc-backupninja Puppet Module Tracker](https://github.com/ULHPC/puppet-backupninja/issues). 

## Developments / Contributing to the code 

If you want to contribute to the code, you shall be aware of the way this module is organized. 
These elements are detailed on [`doc/contributing.md`](doc/contributing.md)

You are more than welcome to contribute to its development by [sending a pull request](https://help.github.com/articles/using-pull-requests). 

## Puppet modules tests within a Vagrant box

The best way to test this module in a non-intrusive way is to rely on [Vagrant](http://www.vagrantup.com/).
The `Vagrantfile` at the root of the repository pilot the provisioning various vagrant boxes available on [Vagrant cloud](https://atlas.hashicorp.com/boxes/search?utf8=%E2%9C%93&sort=&provider=virtualbox&q=svarrette) you can use to test this module.

See [`doc/vagrant.md`](doc/vagrant.md) for more details. 


