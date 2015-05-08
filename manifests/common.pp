# File::      <tt>backupninja.pp</tt>
# Author::    Hyacinthe Cartiaux (hyacinthe.cartiaux@uni.lu)
# Copyright:: Copyright (c) 2012 Hyacinthe Cartiaux
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Class: backupninja::common
#
# Base class to be inherited by the other backupninja classes
#
# Note: respect the Naming standard provided here[http://projects.puppetlabs.com/projects/puppet/wiki/Module_Standards]
class backupninja::common {

    # Load the variables used in this module. Check the backupninja-params.pp file
    require backupninja::params

    package { 'backupninja':
        ensure => $backupninja::ensure,
        name   => $backupninja::params::packagename,
    }


    file { 'backupninja.conf':
        ensure  => $backupninja::ensure,
        path    => $backupninja::params::configfile,
        owner   => $backupninja::params::configfile_owner,
        group   => $backupninja::params::configfile_group,
        mode    => $backupninja::params::configfile_mode,
        content => template('backupninja/backupninja.conf.erb'),
        require => Package['backupninja']
    }

}
