#!/usr/bin/env bash

TAMP_PATH="/data/data/com.termux/files/usr/bin"
CONF_PATH="/data/data/com.termux/files/usr/share/Tamp/CONF_FILE"
if [[ -f $TAMP_PATH/tamp ]]; then
	echo -e "\e[1;34m[\e[1;31m*\e[1;34m] \e[1;34mUpdating Tamp webserver.\e[0m"
	cd $TAMP_PATH
	rm tamp & > /dev/null
	curl -LO https://raw.githubusercontent.com/1Tech-X/Tamp/main/CONF_FILE/tamp &> /dev/null
	chmod +x tamp
	cd $CONF_PATH
	rm httpd.conf & > /dev/null
	curl -LO https://raw.githubusercontent.com/1Tech-X/Tamp/main/CONF_FILE/httpd.conf &> /dev/null
	cd $HOME
	echo -e "\e[1;34m[\e[1;32m Done \e[1;34m]\e[0m"
else
	echo -e "\e[1;31mTamp is not installed.\e[0m"

fi
# After update, it's require to set document otherwise, it's not work

# changing document root using tamp -dc command
tamp -dc
