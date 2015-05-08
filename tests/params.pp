# File::      <tt>params.pp</tt>
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
#      sudo puppet apply -t --parser future /vagrant/tests/params.pp
#
#

include 'backupninja::params'

$names = ['ensure', 'loglevel', 'reportemail', 'reportsuccess', 'reportinfo', 'reportwarning', 'reportspace', 'reporthost', 'reportuser', 'reportdirectory', 'admingroup', 'logfile', 'configdirectory', 'scriptdirectory', 'usecolors', 'when', 'vservers', 'libdirectory', 'packagename', 'configfile', 'configfile_mode', 'taskfile_mode', 'lvmnetbackup_mode', 'configfile_owner', 'configfile_group']

notice("backupninja::params::ensure = ${backupninja::params::ensure}")
notice("backupninja::params::loglevel = ${backupninja::params::loglevel}")
notice("backupninja::params::reportemail = ${backupninja::params::reportemail}")
notice("backupninja::params::reportsuccess = ${backupninja::params::reportsuccess}")
notice("backupninja::params::reportinfo = ${backupninja::params::reportinfo}")
notice("backupninja::params::reportwarning = ${backupninja::params::reportwarning}")
notice("backupninja::params::reportspace = ${backupninja::params::reportspace}")
notice("backupninja::params::reporthost = ${backupninja::params::reporthost}")
notice("backupninja::params::reportuser = ${backupninja::params::reportuser}")
notice("backupninja::params::reportdirectory = ${backupninja::params::reportdirectory}")
notice("backupninja::params::admingroup = ${backupninja::params::admingroup}")
notice("backupninja::params::logfile = ${backupninja::params::logfile}")
notice("backupninja::params::configdirectory = ${backupninja::params::configdirectory}")
notice("backupninja::params::scriptdirectory = ${backupninja::params::scriptdirectory}")
notice("backupninja::params::usecolors = ${backupninja::params::usecolors}")
notice("backupninja::params::when = ${backupninja::params::when}")
notice("backupninja::params::vservers = ${backupninja::params::vservers}")
notice("backupninja::params::libdirectory = ${backupninja::params::libdirectory}")
notice("backupninja::params::packagename = ${backupninja::params::packagename}")
notice("backupninja::params::configfile = ${backupninja::params::configfile}")
notice("backupninja::params::configfile_mode = ${backupninja::params::configfile_mode}")
notice("backupninja::params::taskfile_mode = ${backupninja::params::taskfile_mode}")
notice("backupninja::params::lvmnetbackup_mode = ${backupninja::params::lvmnetbackup_mode}")
notice("backupninja::params::configfile_owner = ${backupninja::params::configfile_owner}")
notice("backupninja::params::configfile_group = ${backupninja::params::configfile_group}")

#each($names) |$v| {
#    $var = "backupninja::params::${v}"
#    notice("${var} = ", inline_template('<%= scope.lookupvar(@var) %>'))
#}
