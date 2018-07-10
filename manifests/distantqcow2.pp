# File::      <tt>backupninja-distantqcow2.pp</tt>
# Author::    Hyacinthe Cartiaux (hyacinthe.cartiaux@uni.lu)
# Copyright:: Copyright (c) 2012 Hyacinthe Cartiaux
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Defines: backupninja::distantqcow2
#
# Configure and manage QCow2 backup with backupninja
#
# == Pre-requisites
#
# * The class 'backupninja' should have been instanciated
#
# == Parameters:
#
# [*ensure*]
#   default to 'present', can be 'absent'.
#   Default: 'present'
#
# == Sample usage:
#
#     include "backupninja"
#
# You can then add a mydef specification as follows:
#
#      backupninja::distantqcow2 {
#
#      }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# [Remember: No empty lines between comments and class definition]
#
define backupninja::distantqcow2(
    $ssh_host,
    $vms,
    $ensure     = 'present',
    $backupdir  = '/var/backups/distantqcow2',
    $ssh_user   = 'localadmin',
    $ssh_port   = '8022',
    $when       = '',
    $keep       = '0'
)
{
    include ::backupninja::params

    # $name is provided at define invocation
    $basename = $name

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("backupninja::distantqcow2 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    if ($backupninja::ensure != $ensure) {
        if ($backupninja::ensure != 'present') {
            fail("Cannot configure a backupninja '${basename}' as backupninja::ensure is NOT set to present (but ${backupninja::ensure})")
        }
    }

    if (! defined( File['/usr/share/backupninja/distantqcow2']) ) {
        file { '/usr/share/backupninja/distantqcow2':
            ensure  => $ensure,
            owner   => $backupninja::params::configfile_owner,
            group   => $backupninja::params::configfile_group,
            mode    => $backupninja::params::taskfile_mode,
            path    => '/usr/share/backupninja/distantqcow2',
            source  => 'puppet:///modules/backupninja/handler_distantqcow2',
            require => Package['backupninja'],
        }
    }

    if (! defined( File['/usr/local/bin/qcow2_net_backup.sh'] ) ) {
        file { '/usr/local/bin/qcow2_net_backup.sh':
            ensure  => $ensure,
            owner   => $backupninja::params::configfile_owner,
            group   => $backupninja::params::configfile_group,
            mode    => $backupninja::params::netbackup_mode,
            path    => '/usr/local/bin/qcow2_net_backup.sh',
            source  => 'puppet:///modules/backupninja/qcow2_net_backup.sh',
            require => Package['backupninja'],
        }
    }

    file { "${basename}.distantqcow2":
        ensure  => $ensure,
        owner   => $backupninja::params::configfile_owner,
        group   => $backupninja::params::configfile_group,
        mode    => $backupninja::params::taskfile_mode,
        path    => "${backupninja::configdirectory}/${basename}.distantqcow2",
        content => template('backupninja/backup.d/distantqcow2.erb'),
        require => Package['backupninja'],
    }
}



