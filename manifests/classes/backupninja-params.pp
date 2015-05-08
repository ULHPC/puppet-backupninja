# File::      <tt>backupninja-params.pp</tt>
# Author::    Hyacinthe Cartiaux (hyacinthe.cartiaux@uni.lu)
# Copyright:: Copyright (c) 2012 Hyacinthe Cartiaux
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Class: backupninja::params
#
# In this class are defined as variables values that are used in other
# backupninja classes.
# This class should be included, where necessary, and eventually be enhanced
# with support for more OS
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# The usage of a dedicated param classe is advised to better deal with
# parametrized classes, see
# http://docs.puppetlabs.com/guides/parameterized_classes.html
#
# [Remember: No empty lines between comments and class definition]
#
class backupninja::params {

    ######## DEFAULTS FOR VARIABLES USERS CAN SET ##########################
    # (Here are set the defaults, provide your custom variables externally)
    # (The default used is in the line with '')
    ###########################################

    # ensure the presence (or absence) of backupninja
    $ensure = $::backupninja_ensure ? {
        ''      => 'present',
        default => $::backupninja_ensure
    }

    $loglevel        = '4'
    $reportemail     = 'root'
    $reportsuccess   = 'no'
    $reportinfo      = 'no'
    $reportwarning   = 'yes'
    $reportspace     = 'yes'
    $reporthost      = ''
    $reportuser      = 'ninja'
    $reportdirectory = '/var/lib/backupninja/reports'
    $admingroup      = 'root'
    $logfile         = '/var/log/backupninja.log'
    $configdirectory = '/etc/backup.d'
    $scriptdirectory = '/usr/share/backupninja'
    $usecolors       = 'yes'
    $when            = 'everyday at 01:00'
    $vservers        = 'no'

    $libdirectory    = $::operatingsystem ? {
        /(?i-mx:centos|fedora|redhat)/ => '/usr/libexec/backupninja',
        /(?i-mx:debian|ubuntu)/        => '/usr/lib/backupninja',
        default                        => '/usr/lib/backupninja'
    }

    #### MODULE INTERNAL VARIABLES  #########
    # (Modify to adapt to unsupported OSes)
    #######################################
    # backupninja packages
    $packagename = $::operatingsystem ? {
        default => 'backupninja',
    }

    $configfile = $::operatingsystem ? {
        default => '/etc/backupninja.conf',
    }
    $configfile_mode = $::operatingsystem ? {
        default => '0644',
    }
    $taskfile_mode = $::operatingsystem ? {
        default => '0600',
    }
    $lvmnetbackup_mode = $::operatingsystem ? {
        default => '0755',
    }
    $configfile_owner = $::operatingsystem ? {
        default => 'root',
    }
    $configfile_group = $::operatingsystem ? {
        default => 'root',
    }


}

