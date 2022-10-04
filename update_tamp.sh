#!/usr/bin/env bash

TAMP_PATH="/data/data/com.termux/files/usr/bin"
CONF_PATH="/data/data/com.termux/files/usr/share/Tamp/CONF_FILE"
if [[ -f $TAMP_PATH/tamp ]]; then
	if grep -F 'killall mysqld &> /dev/null' $TAMP_PATH/tamp &>/dev/null; then
		echo -e "\e[1;34mUpdating tamp....\e[0m"
		cd $TAMP_PATH
		rm tamp
		curl -LO https://raw.githubusercontent.com/1Tech-X/Tamp/main/CONF_FILE/tamp.sh &>/dev/null
		mv tamp.sh tamp
		chmod +x tamp
		echo ""
		echo -e "\e[1;92mDone\e[0m"
		if [[ -d $HOME/Tamp ]];then
			cd $HOME/Tamp/CONF_FILE &>/dev/null
			rm tamp.sh &>/dev/null
			rm tamp &>/dev/null
			curl -LO https://raw.githubusercontent.com/1Tech-X/Tamp/main/CONF_FILE/tamp.sh &>/dev/null
			cp tamp.sh tamp &>/dev/null

		else
			echo ""
		fi
			
	else
		echo ""
		echo -e "\e[1;92mTamp is up to date\e[0m"
	fi
else
	echo -e "\e[1;31mTamp is not installed.\e[0m"

fi

