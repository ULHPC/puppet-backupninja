# File::      <tt>backupninja-pgsql.pp</tt>
# Author::    Hyacinthe Cartiaux (hyacinthe.cartiaux@uni.lu)
# Copyright:: Copyright (c) 2012 Hyacinthe Cartiaux
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Defines: backupninja::pgsql
#
# Configure and manage PostGreSQL backup with backupninja
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
#      backupninja::pgsql {
#          ensure  => 'present',
#      }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# [Remember: No empty lines between comments and class definition]
#
define backupninja::pgsql(
    $ensure     = 'present',
    $databases  = 'all',
    $backupdir  = '/var/backups/pgsql',
    $compress   = 'yes',
    $when       = ''
)
{
    include backupninja::params

    # $name is provided at define invocation
    $basename = $name

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("backupninja::pgsql 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    if ($backupninja::ensure != $ensure) {
        if ($backupninja::ensure != 'present') {
            fail("Cannot configure a backupninja '${basename}' as backupninja::ensure is NOT set to present (but ${backupninja::ensure})")
        }
    }

    file { "${basename}.pgsql":
        ensure  => $ensure,
        path    => "${backupninja::configdirectory}/${basename}.pgsql",
        owner   => $backupninja::params::configfile_owner,
        group   => $backupninja::params::configfile_group,
        mode    => $backupninja::params::taskfile_mode,
        content => template('backupninja/backup.d/pgsql.erb'),
        require => Package['backupninja']
    }
}



