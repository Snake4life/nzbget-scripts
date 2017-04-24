#!/bin/sh

# Scan Script for fetching Password and Category from NZB-Filename

################################################################################
### NZBGET SCAN SCRIPT 			                                             ##

# This Script takes the Password/Category (if available) from NZB-Filename.
#
# Example: [[Computer]]Debian8-Final.iso{{12345}}.nzb
#
#
# It switches the Category to "Computer" and set the password "12345".
#
# Script by ProfDrLuigi (2017)

### NZBGET SCAN SCRIPT                                                       ###
################################################################################

newname=`echo "$NZBNP_FILENAME" | sed -e 's/.*\]//g' -e 's/{.*//g' -e 's/.nzb//g'`

if [[ "$NZBNP_FILENAME" =~ "[[" ]]
then
 cat=`echo "$NZBNP_FILENAME"  | sed -e 's/.*\[//g' -e 's/\].*//g'`
else
 cat=""
fi

if [[ "$NZBNP_FILENAME" =~ "{{" ]]
then
 pass=`echo "$NZBNP_FILENAME" | sed -e 's/.*{//g' -e 's/}.*//g'`
else
 pass=""
fi

echo "[NZB] NZBNAME=$newname";
echo "[NZB] CATEGORY=$cat";
echo "[NZB] NZBPR_*Unpack:Password=$pass";

exit 93
