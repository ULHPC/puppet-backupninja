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

$names = ['ensure', 'protocol', 'port', 'packagename']

notice("backupninja::params::ensure = ${backupninja::params::ensure}")
notice("backupninja::params::protocol = ${backupninja::params::protocol}")
notice("backupninja::params::port = ${backupninja::params::port}")
notice("backupninja::params::packagename = ${backupninja::params::packagename}")

#each($names) |$v| {
#    $var = "backupninja::params::${v}"
#    notice("${var} = ", inline_template('<%= scope.lookupvar(@var) %>'))
#}
