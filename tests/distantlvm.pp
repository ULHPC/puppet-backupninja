# File::      <tt>distantlvm.pp</tt>
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
#      sudo puppet apply -t --parser future /vagrant/tests/distantlvm.pp
#
#

node default {

    class { 'backupninja':
      ensure => 'present'
    }

    backupninja::distantlvm { 'backup_dom0_test':
        ensure    => 'present',
        backupdir => '/data/backup_dom0',
        ssh_host  => 'dom0-server.uni.lu',
        ssh_user  => 'localuser',
        ssh_port  => '22',
        vg        => vg_domU,
        lv        => 'domu1-disk domu2-disk domu3-disk',
        keep      => 5,
        when      => 'mondays at 03:00'
    }

}
