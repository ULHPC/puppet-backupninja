#!/bin/bash
################################################################################
# qcow2_net_backup.sh - Backup qcow2 snapshot over SSH to files
#
# Copyright (c) 2012 Hyacinthe Cartiaux <Hyacinthe.Cartiaux@uni.lu>
#
# Description : see the print_usage function or launch 'qcow2_net_backup.sh --help'
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
################################################################################
#set -x
print_usage()
{
    cat <<EOF

NAME
        qcow2_net_backup.sh - Backup qcow2 snapshot over SSH to files
        Version 0.2

SYNOPSIS
        qcow2_net_backup.sh --dest <dest. dir> --ssh <host>
                          --vm name <vm name>
                          [--keep 0|1|n]
                          [--ssh_config <configfile>] [--dry-run] [-f]

DESCRIPTION
        lvm_net_backup.sh is a ssh based backup tool, that saves distant lvm
        snapshot in a local tarball. It implements a simple rotation system.

ARGUMENTS
        --dest <dest. dir>
                Sets the destination directories where the backups is
                placed.

        --ssh <host>
                Hostname of the distant server

        --ssh_port <port>
                Port of the ssh server

        --ssh_user <user>
                Specifies the user to log in as on the remote machine

        --vm <Virtual Machine name>
                Name of the Virtual Machine on the <host> server

OPTIONS
        --keep <number of days>
                Specify the number of backups you want to keep.
                '0'        Do not delete, keep all the backups
                '1'        Keep the last backup
                'n'        Keep the n last backups
                Default is '0'

        --dry-run
                Test mode, does nothing, print commands

        -f
                Force, do not ask for confirmation


EXAMPLES
        lvm_net_backup.sh --dest /data --ssh shiva \\
                          --vm www --keep 10

        When this command is launched, it checks if an action must be done
        (depending on existing backup), and apply the rotation policy (delete
        old backups)
        This will produce a snapshot of host=shiva/vm=www
        in the directory /data on the local host. The file will be written at
        the following paths : host/vm/year/month/day/host-vm-ymd.qcow2.gz

AUTHOR
    Hyacinthe Cartiaux <Hyacinthe.Cartiaux@uni.lu>

REPORTING BUGS
    Please report bugs to <Hyacinthe.Cartiaux@uni.lu>

COPYRIGHT
    This is free software; see the source for copying conditions.  There is
    NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR
    PURPOSE.

EOF
    exit 1
}

exec_cmd() {
  if [ "x$1" == "xDRY_RUN" ] ; then
    shift
    report "[DRY-RUN] $*"
  else
    report "[CMD] $*"
    $* &> /dev/null
    return $?
  fi
}

report() {
  echo "[INFO] $*"
}

ask() {
  echo -n "[INTERACTIVE] $* "
}

error() {
  echo "[ERROR] $*" 1>&2
}

fail() {
  echo "[FAIL] $*" 1>&2
  exit 1
}




######################################
############# PARAMETERS #############
######################################

# Defaults
PORT=22
USER=root
KEEP=0
DRY_RUN=
FORCE=

SNAPSHOT_SIZE="1G"
MINAVAIL="10000000"
MINIAVAIL="1000"

# Parsing
opts=$@
args=($opts)
index=0
for args in $opts
do
  index=$((index + 1))
  case $args in
    --dest)       DEST=${args[index]}       ;;
    --ssh)        HOST=${args[index]}       ;;
    --ssh_user)   USER=${args[index]}       ;;
    --ssh_port)   PORT=${args[index]}       ;;
    --vm)           VM=${args[index]}       ;;
    --keep)       KEEP=${args[index]}       ;;
    --dry-run)    DRY_RUN="DRY_RUN"         ;;
    -f)           FORCE=-f                  ;;
  esac
done

# variables
ERR=0

YEAR=$(date +%Y)
MONTH=$(date +%m)
DAY=$(date +%d)
DEST_BACKUP_DIR=${DEST}/
DEST_BACKUP_FILE=${HOST}_${VM}_${YEAR}_${MONTH}_${DAY}.qcow2

SSH="ssh -p ${PORT} ${USER}@${HOST} -o StrictHostKeyChecking=no"
RSYNC="rsync -avz -e 'ssh -p ${PORT} -o StrictHostKeyChecking=no -l ${USER}' --rsync-path='sudo rsync' ${HOST}:"

# Checks
if [ "x$DEST" == "x" ] ; then
  error "--dest parameter undefined"
  ERR=1
fi
if [ "x$HOST" == "x" ] ; then
  error "--ssh parameter undefined"
  ERR=1
fi
if [ "x$VM"   == "x" ] ; then
  error "--vm parameter undefined"
  ERR=1
fi

if [ "x$ERR"  == "x1" ] ; then
  print_usage
  fail "Missing parameters, read the manual above !"
fi

# Confirm
report "--dest       = ${DEST}"
report "--ssh        = ${HOST}"
report "--ssh_port   = ${PORT}"
report "--ssh_user   = ${USER}"
report "--vm         = ${VM}"
report "--keep       = ${KEEP}"
report "FORCE=${FORCE} DRY_RUN=${DRY_RUN}"


if [ "x$FORCE" != "x-f" ] ; then
  ask "Confirm ? Y/N [N]"
  read confirm

  if [ "x$confirm" != "xY" -a "x$confirm" != "xy"  ] ; then
    report "Exiting now !"
    exit 3
  else
    report "Continue"
  fi
fi


###############################################
############# Pre execution tests #############
###############################################

## dest directory
if [ ! -d "$DEST" ] ; then
  fail "Can't find destination directory ${DEST} !"
fi

if [ "x$USER" != "xroot" ] ; then
  SUDO="sudo "
fi

## SSH connection
exec_cmd $DRY_RUN $SSH true
if [ "x$?" != "x0" ] ; then
  fail "Connection to ${HOST} failed !"
fi

## VM exists, extract blk fs
exec_cmd $DRY_RUN $SSH "${SUDO}virsh domblklist ${VM} | grep vda"
if [ "x$?" != "x0" ] ; then
  fail "Can't find VM ${VM} on ${HOST} !"
else
  BLKFILE=$($SSH "${SUDO}virsh domblklist ${VM} | grep vda | awk '{print \$2}'")
  $SSH "${SUDO} test \$(df --output=avail . | tail -n1) -gt ${MINAVAIL} && test \$(df --output=iavail . | tail -n1) -gt ${MINIAVAIL}"
  if [ "x$?" != "x0" ] ; then
    fail "Not enough space to create a snapshot on ${HOST} !"
  fi
fi

exec_cmd $DRY_RUN $SSH true
if [ "x$?" != "x0" ] ; then
  fail "Connection to ${HOST} failed !"
fi

############################################
############ Snapshot creation #############
############################################

# Create snapshot
exec_cmd $DRY_RUN $SSH "${SUDO}virsh snapshot-create-as --domain ${VM} ${VM}-backupsnap --diskspec vda,file=${BLKFILE}_overlay.qcow2 --disk-only --atomic"
if [ "x$?" != "x0" ] ; then
  error "Can't create snapshot ${VM}-backupsnap !"
  ERR=1
fi


################################
############# Save #############
################################

# tar and save locally
if [ "x$ERR"  == "x1" ] ; then
  error "Can't backup !"
elif [ "x$DRY_RUN" == "xDRY_RUN" ] ; then
    report   "[DRY-RUN] ${RSYNC}${BLKFILE} ${DEST_BACKUP_DIR}${DEST_BACKUP_FILE}"
else
    exec_cmd $DRY_RUN mkdir -p $DEST_BACKUP_DIR
    report       "[CMD] ${RSYNC}${BLKFILE} ${DEST_BACKUP_DIR}${DEST_BACKUP_FILE}"
                  eval "${RSYNC}${BLKFILE} ${DEST_BACKUP_DIR}${DEST_BACKUP_FILE}"
    if [ "x$?" != "x0" ] ; then
      error "Can't retrieve ${BLKFILE} into ${DEST_BACKUP_DIR}${DEST_BACKUP_FILE} !"
      exec_cmd $DRY_RUN rm -f ${DEST_BACKUP_DIR}${DEST_BACKUP_FILE}
      ERR=1
    fi

    exec_cmd $DRY_RUN gzip ${DEST_BACKUP_DIR}${DEST_BACKUP_FILE}
    if [ "x$?" != "x0" ] ; then
      error "Can't gzip ${DEST_BACKUP_DIR}${DEST_BACKUP_FILE} !"
      exec_cmd $DRY_RUN rm -f ${DEST_BACKUP_DIR}${DEST_BACKUP_FILE}
      ERR=1
    fi
fi


###################################
############# Clean ! #############
###################################





# Delete snapshot
exec_cmd $DRY_RUN $SSH "${SUDO}virsh blockcommit ${VM} vda --active --verbose --pivot"
RET1=$?
exec_cmd $DRY_RUN $SSH "${SUDO}virsh snapshot-delete ${VM} --metadata ${VM}-backupsnap"
RET2=$?
exec_cmd $DRY_RUN $SSH "${SUDO}rm -f ${BLKFILE}_overlay.qcow2"
RET3=$?

if [ "x$RET1$RET2$RET3" != "x000" ] ; then
  fail "Can't remove snapshot ${VM}-backupsnap !"
  ERR=1
fi


#########################################
############# Rotation work #############
#########################################

if [[ "$KEEP" != "0" && "x$ERR" == "x0" ]] ; then

  nbrfiles=`/bin/ls -c1 ${DEST_BACKUP_DIR}${HOST}_${VM}_* 2>/dev/null | wc -l`
  let "nbroldbackups = $nbrfiles - $KEEP"

  if [ $nbroldbackups -gt 0 ] ; then

    for i in `/bin/ls -c1 ${DEST_BACKUP_DIR}${HOST}_${VM}_* 2>/dev/null | sort | head -n $nbroldbackups` ; do
      exec_cmd $DRY_RUN "rm $i"
      if [ "x$?" != "x0" ] ; then
        error "Can't delete file $i !"
        ERR=1
      fi
    done

  fi

elif [[ "$KEEP" != "0" && "x$ERR" == "x1" ]]; then
    error "Error(s) detected, no backup removed !"
fi

exit $ERR

