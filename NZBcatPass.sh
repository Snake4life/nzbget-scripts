#!/bin/bash

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
# Script by ProfDrLuigi (2017) + Docker ready by Snake4life (2020)

### NZBGET SCAN SCRIPT                                                       ###
################################################################################

set > /tmp/set

#	back it up for ever:
if [[ ! -z "$NZBNP_CATEGORY" ]];then
	#echo "[NZB] PRIORITY=50"				optionaly
	t_name="[[$NZBNP_CATEGORY]]"$(echo "$NZBNP_NZBNAME" | tr ' ' '.') 			#	its allway an good idea to remove whitspaces in linux
else
	t_name=$(echo "$NZBNP_NZBNAME" | tr ' ' '.')
fi

#gzip -c "$NZBNP_FILENAME" > "$NZBOP_MAINDIR/nzbbackup/"$t_name.gz 				#	optionally backup nzbs / usefull in my case

newname=$(echo "$NZBNP_FILENAME" | sed -e 's/.*\]//g' -e 's/{.*//g' -e 's/.nzb//g' | tr ' ' '.')	#	added remove whitespaces

if [[ "$NZBNP_FILENAME" =~ "[[" ]]
then
	cat=$(echo "$NZBNP_FILENAME"  | sed -e 's/.*\[//g' -e 's/\].*//g')
else
	cat="$NZBNP_CATEGORY"														#	if user passes its own category its used, otherwise its empty value
fi

if [[ "$NZBNP_FILENAME" =~ "{{" ]]
then
	pass=$(echo "$NZBNP_FILENAME" | sed -e 's/.*{//g' -e 's/}.*//g')
else
	pass=""
fi

echo "[NZB] NZBNAME=$newname";
echo "[NZB] CATEGORY=$cat";
echo "[NZB] NZBPR_*Unpack:Password=$pass";

echo "[NZBCatPass.sh] NZBNAME: $newname";
echo "[NZBCatPass.sh] CATEGORY: $cat";
echo "[NZBCatPass.sh] PASSWORD: $pass";

exit 93
