# File::      <tt>rsync.pp</tt>
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
#      sudo puppet apply -t --parser future /vagrant/tests/rsync.pp
#
#

node default {

    class { 'backupninja':
      ensure => 'present'
    }

    backupninja::rsync { 'backup_rsync_test':
      ensure              => 'present',
      mountpoint          => '/data/rsync',
      backupdir           => 'backed-up-server',
      source_type         => 'remote',
      source_protocol     => 'ssh',
      source_host         => 'backed-up-server.uni.lu',
      source_port         => '2222',
      source_user         => 'localuser',
      source_include      => '/etc',
      dest_type           => 'local',
      when                => 'everyday at 02',
      keepdaily           => '10',
      keepweekly          => '5',
      keepmonthly         => '3',
      source_remote_rsync => 'sudo rsync'
    }


}
