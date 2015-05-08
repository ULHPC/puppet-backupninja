# File::      <tt>backupninja-ldap.pp</tt>
# Author::    Hyacinthe Cartiaux (hyacinthe.cartiaux@uni.lu)
# Copyright:: Copyright (c) 2012 Hyacinthe Cartiaux
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Defines: backupninja::ldap
#
# Configure and manage OpenLdap / slapd backup with backupninja
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
#    backupninja::ldap { 'backup_ldap-server':
#        ensure => present,
#    }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# [Remember: No empty lines between comments and class definition]
#
define backupninja::ldap(
    $ensure       = 'present',
    $databases    = 'all',
    $backupdir    = '/var/backups/ldap',
    $conf         = '/etc/ldap/slapd.conf',
    $compress     = 'yes',
    $restart      = 'no',
    $backupmethod = 'slapcat',
    $passwordfile = '',
    $binddn       = 'cn=admin,dc=uni,dc=lu',
    $ldaphost     = 'localhost',
    $ssl          = 'no',
    $tls          = 'yes',
    $when         = ''
)
{
    include backupninja::params

    # $name is provided at define invocation
    $basename = $name

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("backupninja::ldap 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    if ! ($backupmethod in [ 'slapcat', 'ldapsearch' ]) {
        fail("backupninja::ldap 'method' parameter must be set to either 'slapcat' or 'ldapsearch'")
    }

    if ($backupmethod == 'ldapsearch' and ($binddn == '' or $ldaphost == '')) {
        fail("backupninja::ldap 'binddn' and 'ldaphost' parameters must be set if method is 'ldapsearch'")
    }

    if ($backupninja::ensure != $ensure) {
        if ($backupninja::ensure != 'present') {
            fail("Cannot configure a backupninja '${basename}' as backupninja::ensure is NOT set to present (but ${backupninja::ensure})")
        }
    }

    file { "${basename}.ldap":
        ensure  => $ensure,
        path    => "${backupninja::configdirectory}/${basename}.ldap",
        owner   => $backupninja::params::configfile_owner,
        group   => $backupninja::params::configfile_group,
        mode    => $backupninja::params::taskfile_mode,
        content => template('backupninja/backup.d/ldap.erb'),
        require => Package['backupninja']
    }
}



