# File::      <tt>backupninja-distantlvm.pp</tt>
# Author::    Hyacinthe Cartiaux (hyacinthe.cartiaux@uni.lu)
# Copyright:: Copyright (c) 2012 Hyacinthe Cartiaux
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Defines: backupninja::distantlvm
#
# Configure and manage LVM backup with backupninja
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
#    backupninja::distantlvm { 'backup_dom0_test':
#        ensure     => 'present',
#        backupdir  => '/data/backup_dom0',
#        ssh_host   => 'dom0-server.uni.lu',
#        ssh_user   => 'localuser',
#        ssh_port   => '22',
#        vg         => vg_domU,
#        lv         => 'domu1-disk domu2-disk domu3-disk',
#        keep       => 5,
#        when       => 'mondays at 03:00'
#    }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# [Remember: No empty lines between comments and class definition]
#
define backupninja::distantlvm(
    $ssh_host,
    $vg,
    $lv,
    $ensure     = 'present',
    $backupdir  = '/var/backups/distantlvm',
    $ssh_user   = 'localadmin',
    $ssh_port   = '8022',
    $when       = '',
    $keep       = '0'
)
{
    include backupninja::params

    # $name is provided at define invocation
    $basename = $name

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("backupninja::distantlvm 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    if ($backupninja::ensure != $ensure) {
        if ($backupninja::ensure != 'present') {
            fail("Cannot configure a backupninja '${basename}' as backupninja::ensure is NOT set to present (but ${backupninja::ensure})")
        }
    }

    if (! defined( File['/usr/share/backupninja/distantlvm']) ) {
        file { '/usr/share/backupninja/distantlvm':
            ensure  => $ensure,
            path    => '/usr/share/backupninja/distantlvm',
            owner   => $backupninja::params::configfile_owner,
            group   => $backupninja::params::configfile_group,
            mode    => $backupninja::params::taskfile_mode,
            source  => 'puppet:///modules/backupninja/handler_distantlvm',
            require => Package['backupninja']
        }
    }

    if (! defined( File['/usr/local/bin/lvm_net_backup.sh'] ) ) {
        file { '/usr/local/bin/lvm_net_backup.sh':
            ensure  => $ensure,
            path    => '/usr/local/bin/lvm_net_backup.sh',
            owner   => $backupninja::params::configfile_owner,
            group   => $backupninja::params::configfile_group,
            mode    => $backupninja::params::lvmnetbackup_mode,
            source  => 'puppet:///modules/backupninja/lvm_net_backup.sh',
            require => Package['backupninja']
        }
    }

    file { "${basename}.distantlvm":
        ensure  => $ensure,
        path    => "${backupninja::configdirectory}/${basename}.distantlvm",
        owner   => $backupninja::params::configfile_owner,
        group   => $backupninja::params::configfile_group,
        mode    => $backupninja::params::taskfile_mode,
        content => template('backupninja/backup.d/distantlvm.erb'),
        require => Package['backupninja']
    }
}



