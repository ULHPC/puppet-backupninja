# File::      <tt>backupninja.pp</tt>
# Author::    Hyacinthe Cartiaux (hyacinthe.cartiaux@uni.lu)
# Copyright:: Copyright (c) 2012 Hyacinthe Cartiaux
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Class: backupninja
#
# Configure and manage backupninja
#
# == Parameters:
#
# $ensure:: *Default*: 'present'.
# Ensure the presence (or absence) of backupninja
#
# $log_level:: *Default*: '4'.
# How verbose to make the logs
#
# $reportemail:: *Default*: 'root'.
# Send a summary of the backup status to this mail
#
# $reportsuccess:: *Default*: 'no'.
# If set to 'yes', a report email will be generated even if all modules reported success
#
# $reportinfo:: *Default*: 'no'.
# If set to 'yes', info messages from handlers will be sent into the email
#
# $reportwarning:: *Default*: 'yes'.
# If set to 'yes', a report email will be generated even if there was no error
#
# $reportspace:: *Default*: 'yes'.
# If set to 'yes', disk space usage will be included in the backup email report
#
# $reporthost:: *Default*: empty.
# Where to rsync the backupninja.log to be aggregated in a ninjareport
#
# $reportuser:: *Default*: 'ninja'.
# What user to connect to reporthost to sync the backupninja.log
#
# $reportdirectory:: *Default*: '/var/lib/backupninja/reports'. Where on the
# reporthost should the report go. NOTE: the name of the log will be used in
# the report, use a globally unique name, preferably the hostname
#
# $admingroup:: *Default*: 'root'. Set to the administration group that is
# allowed to read/write configuration files in /etc/backup.d
#
# $logfile:: *Default*: '/var/log/backupninja.log'. Where to log
#
# $configdirectory:: *Default*: '/etc/backup.d'.
# Directory where all the backup configuration files live
#
# $scriptdirectory:: *Default*: '/usr/share/backupninja'.
# Where backupninja helper scripts are found
#
# $libdirectory:: *Default*: '/usr/lib/backupninja'.
# Where backupninja libs are found
#
# $usecolors:: *Default*: 'yes'.
# Whether to use colors in the log file
#
# $when:: *Default*: 'everyday at 01:00'.
# Default value for 'when'
#
# $vservers:: *Default*: 'no'.
# If running vservers, set to yes
#
# == Actions:
#
# Install and configure backupninja
#
# == Requires:
#
# n/a
#
# == Sample Usage:
#
#     import backupninja
#
# You can then specialize the various aspects of the configuration,
# for instance:
#
#         class { 'backupninja':
#             ensure => 'present'
#         }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
#
# [Remember: No empty lines between comments and class definition]
#
class backupninja(
    $ensure          = $backupninja::params::ensure,
    $log_level       = $backupninja::params::loglevel,
    $reportemail     = $backupninja::params::reportemail,
    $reportsuccess   = $backupninja::params::reportsuccess,
    $reportinfo      = $backupninja::params::reportinfo,
    $reportwarning   = $backupninja::params::reportwarning,
    $reportspace     = $backupninja::params::reportspace,
    $reporthost      = $backupninja::params::reporthost,
    $reportuser      = $backupninja::params::reportuser,
    $reportdirectory = $backupninja::params::reportdirectory,
    $admingroup      = $backupninja::params::admingroup,
    $logfile         = $backupninja::params::logfile,
    $configdirectory = $backupninja::params::configdirectory,
    $scriptdirectory = $backupninja::params::scriptdirectory,
    $libdirectory    = $backupninja::params::libdirectory,
    $usecolors       = $backupninja::params::usecolors,
    $when            = $backupninja::params::when,
    $vservers        = $backupninja::params::vservers
)
inherits backupninja::params
{
    info ("Configuring backupninja (with ensure = ${ensure})")

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("backupninja 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    case $::operatingsystem {
        debian, ubuntu:         { include backupninja::common::debian }
        centos, redhat:         { include backupninja::common::redhat }
        default: {
            fail("Module ${module_name} is not supported on ${::operatingsystem}")
        }
    }
}
