#!/bin/sh

# post-processing script for transmitting downloads via rsync

################################################################################
### NZBGET POST-PROCESSING SCRIPT                                            ###

# Transmit downloaded Files via rsync to another place.
#
# Version 1.1 by ProfDrLuigi
#
#
# This script is meant to be used with a Unix/POSIX System. If you want to
# adapt it for Windows dont hesitate to do it. (-:
#
# NOTE: Important note for running this Script you need the following:
#
# - rsync (in case you want to use SSH/Rsync Transfer).
#
# - ncftpput (in case you want to use FTP Transfer).
# NOTE: ncftpput is normally provided with the "ncftp"-Package
#
#
# - sshpass (in case you want to transfer via rsync/scp without using
#   key authentication).

################################################################################
### OPTIONS                                                                  ###

# Select transfer mode (Rsync, SCP, FTP, Local).
# Local means e.g. mounted SMB-Shares etc.
#Protocol=Rsync

# Password authentication(yes, no).
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
dest="$NZBPO_Destination"
destssh="$NZBPO_Username@$NZBPO_Hostname:$NZBPO_Destination/"

if [[ $NZBPO_Protocol = "Rsync" ]]; then
   if [[ $NZBPO_Passauth = "no" ]]; then
   rsync ${opts[@]} --progress -av -e "ssh -p $NZBPO_Port" "$src" "$destssh" | stdbuf -oL tr '\r' '\n'
      if [ $? = 1 ]; then
      touch _error_
      fi
   else
   sshpass -p '$NZBPO_Password' rsync ${opts[@]} --progress -av -e "ssh -p $NZBPO_Port" "$src" "$destssh" | stdbuf -oL tr '\r' '\n'
      if [ $? = 1 ]; then
      touch _error_
      fi
   fi
fi

if [[ $NZBPO_Protocol = "SCP" ]]; then
   if [[ $NZBPO_Passauth = "no" ]]; then
   scp -P $NZBPO_Port "$src" "$destssh"
      if [ $? = 1 ]; then
      touch _error_
      fi
   else
   sshpass -p '$NZBPO_Password' scp -P $NZBPO_Port "$src" "$destssh"
      if [ $? = 1 ]; then
      touch _error_
      fi
   fi
fi

if [[ $NZBPO_Protocol = "FTP" ]]; then
   if [[ $NZBPO_Passauth = "no" ]]; then
   ncftpput -R -v -u "anonymous" -p "" "$NZBPO_Hostname" "$dest" "$src"
      if [ $? = 1 ]; then
      touch _error_
      fi
   else
   ncftpput -R -v -u "$NZBPO_Username" -p "$NZBPO_Password" "$NZBPO_Hostname" "$dest" "$src"
      if [ $? = 1 ]; then
      touch _error_
      fi
   fi
fi

if [[ $NZBPO_Protocol = "Local" ]]; then
   cp -rv "$src" "$dest"
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

fi

exit 93
