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
# - lftp (in case you want to use FTP Transfer)
#
# - For now you need SSH Keyfile-Autologin (ssh-keygen) to the destination
# Server. Log/Pass authentication is planned in future Versions of this
# Script.

################################################################################
### OPTIONS                                                                  ###

# Select transfer mode (Rsync, SCP, FTP, Local).
# Local means e.g. mounted SMB-Shares etc.
#Protocol=Rsync

# Password authentication on SSH(yes, no).
#Passauth=no

# Remote hostname
#Hostname=your.hostname.xy

# rsync/SSH Port on destination Machine(1-65535).
# Default for rsync/SCP=22 FTP=21
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

if [[ $NZBPO_Protocol = "Rsync" ]]; then
   if [[ $NZBPO_Passauth = "no" ]]; then
   rsync ${opts[@]} --progress -av -e "ssh -p $NZBPO_Port" "$src" "$dest" | stdbuf -oL tr '\r' '\n'
      if [ $? = 1 ]; then
      touch _error_
      fi
   else
   echo "Transfer with auth"
      if [ $? = 1 ]; then
      touch _error_
      fi
   fi
fi

if [[ $NZBPO_Protocol = "SCP" ]]; then
   if [[ $NZBPO_Passauth = "no" ]]; then
   scp -P $NZBPO_Port "$src" "$dest"
      if [ $? = 1 ]; then
      touch _error_
      fi
   else
   echo "Transfer with auth"
      if [ $? = 1 ]; then
      touch _error_
      fi
   fi
fi



if [[ $NZBPO_Protocol = "FTP" ]]; then
   if [[ $NZBPO_Passauth = "no" ]]; then
   lftp -e "mirror -R {$src} {$dst}" -u anonymous {$NZBPO_Hostname}
      if [ $? = 1 ]; then
      touch _error_
      fi
   else
   lftp -e "mirror -R {$src} {$dst}" -u {$NZBPO_Username},{$NZBPO_Password} {$NZB_Hostname}
      if [ $? = 1 ]; then
      touch _error_
      fi
   fi
fi

if [[ $NZBPO_Protocol = "Local" ]]; then
   cp --args -r "$src" "$dest"
      if [ $? = 1 ]; then
      touch _error_
      fi
fi

if [ -f _error_ ]; then
rm _error_
exit 94
else
if [ $? = 0 ]; then
   if [[ $NZBPO_Delete = "yes" ]]; then
   rm -r "$NZBPP_DIRECTORY"
   fi
fi

exit 93
