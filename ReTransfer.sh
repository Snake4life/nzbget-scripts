#!/bin/sh

# post-processing script for transmitting downloads via rsync

################################################################################
### NZBGET POST-PROCESSING SCRIPT                                            ###

# Transmit downloaded Files via rsync to another place.
#
# Version 1.0(b) by ProfDrLuigi
#
#
# NOTE: Important note for running this Script you need the following:
# - rsync
#
# - For now you need SSH Keyfile-Autologin (ssh-keygen) to the destination
# Server. Log/Pass authentication is planned in future Versions of this
# Script.

################################################################################
### OPTIONS                                                                  ###

# Select your protocol (SSH, FTP).
#Protocol=SSH

# Password authentication on SSH(yes, no).
#Passauth=no

# Remote hostname
#Hostname=your.hostname.xy

# rsync/SSH Port on destination Machine(1-65535).
# Default for SSH=22 FTP=21 SMB=?
#Port=22

# Remote username
#Username=

# Password
#Password=

# Remote path destination.
# Trailing "/" is not needed
#Destination=

# Delete Sourcefile(s) after successful Transfer (yes, no).
#Delete=No

### NZBGET POST-PROCESSING SCRIPT                                            ###
################################################################################

src="$NZBPP_DIRECTORY"
dest="$NZBPO_Username@$NZBPO_Hostname:$NZBPO_Path/"

rsync ${opts[@]} --progress -av -e "ssh -p $NZBPO_Port" "$src" "$dest" | stdbuf -oL tr '\r' '\n'

if [ $? = 0 ]; then
   if [[ $NZBPO_Delete = "yes" ]]; then
   rm -r "$NZBPP_DIRECTORY"
   fi
else
   exit 94
fi

exit 93
