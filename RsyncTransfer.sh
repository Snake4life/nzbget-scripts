#!/bin/sh

# post-processing script for transmitting downloads via rsync

################################################################################
### NZBGET POST-PROCESSING SCRIPT                                            ###

# Transmit downloaded Files via rsync to another place.
#
# Version 1.0 by ProfDrLuigi
#
#
# To run this script you need:
# - rsync
#
# For now you need SSH Keyfile-Autologin (ssh-keygen) to the destination
# Server. Log/Pass authentication is planned in future Versions of this
# Script.

################################################################################
### OPTIONS                                                                  ###

# Should the Sourcefile(s) be deleted after Transfer (y/n)?
#Delete=n

# rsync/SSH Port on destination Machine (default is 22)
#Port=22

# Remote Hostname
#Hostname=your.hostname.xy

# Remote Username
#User=Your Username

# Remote Path (trailing / is not needed)
#Path=Destinationpath

### NZBGET POST-PROCESSING SCRIPT                                            ###
################################################################################

src="$NZBPP_DIRECTORY"
dest="$NZBPO_User@$NZBPO_Hostname:$NZBPO_Path/"

rsync ${opts[@]} --progress -av -e "ssh -p $NZBPO_Port" "$src" "$dest" | stdbuf -oL tr '\r' '\n'

if [ $? = 0 ]; then
   if [[ $NZBPO_Delete = "y" ]]; then
   rm -r "$NZBPP_DIRECTORY"
   fi
else
   exit 94
fi

exit 93
