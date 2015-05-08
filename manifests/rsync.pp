# File::      <tt>backupninja-rsync.pp</tt>
# Author::    Hyacinthe Cartiaux (hyacinthe.cartiaux@uni.lu)
# Copyright:: Copyright (c) 2012 Hyacinthe Cartiaux
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Defines: backupninja::rsync
#
# Configure and manage backup via rsync with backupninja
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
#      backupninja::rsync { 'backup_rsync_test':
#         ensure              => 'present',
#         mountpoint          => '/data/rsync',
#         backupdir           => 'backed-up-server',
#         source_type         => 'remote',
#         source_protocol     => 'ssh',
#         source_host         => 'backed-up-server.uni.lu',
#         source_port         => '2222',
#         source_user         => 'localuser',
#         source_include      => '/etc',
#         dest_type           => 'local',
#         when                => 'everyday at 02',
#         keepdaily           => '10',
#         keepweekly          => '5',
#         keepmonthly         => '3',
#         source_remote_rsync => 'sudo rsync'
#      }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# [Remember: No empty lines between comments and class definition]
#
define backupninja::rsync(
    $ensure      = 'present',
    $when        = '',
    $log         = '/var/log/backup/rsync.log',
    $mountpoint  = '/data',
    $backupdir   = 'rsync',
    $compress    = 'yes',
    $numericids  = '0',
    $days        = '',
    $keepdaily   = '5',
    $keepweekly  = '3',
    $keepmonthly = '1',
    $lockfile    = '',
    $nicelevel   = '0',
    $tmp         = '/tmp',
    $source_type            = 'remote',
    $source_protocol        = 'ssh',
    $source_host            = '',
    $source_port            = '8022',
    $source_user            = 'localadmin',
    $source_id_file         = '',
    $source_include         = '',
    $source_exclude         = '',
    $source_ssh_cmd         = 'ssh',
    $source_rsync_cmd       = '',
    $source_rsync_options   = '-av --delete',
    $source_bandwidthlimit  = '',
    $source_remote_rsync    = 'rsync',
    $dest_type              = 'local',
    $dest_protocol          = 'ssh',
    $dest_host              = '',
    $dest_port              = '',
    $dest_user              = '',
    $dest_id_file           = '',
    $dest_ssh_cmd           = 'ssh',
    $dest_bandwidthlimit    = '',
    $dest_remote_rsync      = 'rsync'
)
{
    include backupninja::params

    # $name is provided at define invocation
    $basename = $name

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("backupninja::rsync 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    if ($backupninja::ensure != $ensure) {
        if ($backupninja::ensure != 'present') {
            fail("Cannot configure a backupninja '${basename}' as backupninja::ensure is NOT set to present (but ${backupninja::ensure})")
        }
    }

    if ! ($source_type in [ 'local', 'remote' ]) {
        fail("backupninja::rsync 'source_type' parameter must be set to either 'local' or 'remote'")
    }
    if ! ($dest_type in [ 'local', 'remote' ]) {
        fail("backupninja::rsync 'dest_type' parameter must be set to either 'local' or 'remote'")
    }
    if ! ($source_protocol in [ 'rsync', 'ssh' ]) {
        fail("backupninja::rsync 'source_protocol' parameter must be set to either 'rsync' or 'ssh'")
    }
    if ! ($dest_protocol in [ 'rsync', 'ssh' ]) {
        fail("backupninja::rsync 'dest_protocol' parameter must be set to either 'rsync' or 'ssh'")
    }

    $source_include_array = any2array($source_include)
    $source_exclude_array = any2array($source_exclude)

    file { "${mountpoint}/${backupdir}":
        ensure  => 'directory',
        path    => "${mountpoint}/${backupdir}",
        owner   => $backupninja::params::configfile_owner,
        group   => $backupninja::params::configfile_group,
        mode    => $backupninja::params::taskfile_mode,
        require => Exec["mkdir_${mountpoint}/${backupdir}"]
    }
    exec { "mkdir_${mountpoint}/${backupdir}":
        path    => [ '/bin', '/usr/bin' ],
        command => "mkdir -p ${mountpoint}/${backupdir}",
        unless  => "test -d ${mountpoint}/${backupdir}",
    }

    file { "${basename}.rsync":
        ensure  => $ensure,
        path    => "${backupninja::configdirectory}/${basename}.rsync",
        owner   => $backupninja::params::configfile_owner,
        group   => $backupninja::params::configfile_group,
        mode    => $backupninja::params::taskfile_mode,
        content => template('backupninja/backup.d/rsync.erb'),
        require => Package['backupninja']
    }

}



