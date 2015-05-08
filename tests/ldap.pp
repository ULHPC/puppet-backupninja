# File::      <tt>ldap.pp</tt>
# Author::    UL HPC Management Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2015 UL HPC Management Team
# License::   Gpl-3.0
#
# ------------------------------------------------------------------------------
# You need the 'future' parser to be able to execute this manifest (that's
# required for the each loop below).
#
# Thus execute this manifest in your vagrant box as follows:
#
#      sudo puppet apply -t --parser future /vagrant/tests/ldap.pp
#
#

node default {

    class { 'backupninja':
      ensure => 'present'
    }

    backupninja::ldap { 'backup_ldap-server':
        ensure => present,
    }

}
