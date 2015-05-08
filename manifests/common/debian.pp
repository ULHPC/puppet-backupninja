# File::      <tt>backupninja.pp</tt>
# Author::    Hyacinthe Cartiaux (hyacinthe.cartiaux@uni.lu)
# Copyright:: Copyright (c) 2012 Hyacinthe Cartiaux
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Class: backupninja::common::debian
#
# Specialization class for Debian systems
class backupninja::common::debian inherits backupninja::common {
    file { '/usr/share/backupninja/rsync':
        ensure  => $backupninja::ensure,
        owner   => $backupninja::params::configfile_owner,
        group   => $backupninja::params::configfile_group,
        mode    => $backupninja::params::taskfile_mode,
        source  => 'puppet:///modules/backupninja/handler_rsync_118d7587',
        require => Package['backupninja']
    }
}
