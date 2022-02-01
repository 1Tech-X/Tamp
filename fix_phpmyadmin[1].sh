#!/usr/bin/env bash

#Check all Tamp webserver packages
check_Packages() {
for i in apache2 mariadb php php-apache phpmyadmin; do                  
	dpkg -s $i &> /dev/null
	if [[ $? -eq 0 ]]; then
                echo -e "\e[1;34m[\e[\e[1;92m+\e[1;34m]\e[1;92m${i}\e[0m is Installed"
	else
                echo -e "\e[1;34m[\e[1;31m-\e[1;34m]\e[1;31m${i}\e[0m is not Installed"

        fi
done
}
#This phpMyAdmin-5.1.2-all-languages fix all errors
phpMyAdmin()
{
	if [[ -d $PREFIX/share/phpmyadmin ]];then
		spinner=( '█■■■■' '■█■■■' '■■█■■' '■■■█■' '■■■■█' )
		for i in "${spinner[@]}"
		do
			echo -ne "\033[1;34m\r[\e[1;31m*\e[1;34m] Removing phpmyadmin 5.1.1-1 directory \e[34m[\033[31m$i\033[34m]\033[0m   ";
			rm -rf $PREFIX/share/phpmyadmin
			sleep .3s
		done
			printf "\b\b\b\b\b\b\b\b";
			printf "   \b\b\b\b\b"
			printf "\e[1;34m[\e[1;32m Done \e[1;34m]\e[0m";
			echo ""
			echo ""
			echo -e "\e[1;34m[\e[\e[1;92m~\e[1;34m]\e[1;32m Downloading phpMyAdmin-5.1.2-all-languages\e[0m"
			cd $PREFIX/share
			wget https://files.phpmyadmin.net/phpMyAdmin/5.1.2/phpMyAdmin-5.1.2-all-languages.zip
			unzip phpMyAdmin-5.1.2-all-languages.zip
			clear
			mv phpMyAdmin-5.1.2-all-languages phpmyadmin 
			ln -s $PREFIX/etc/phpmyadmin/config.inc.php $PREFIX/share/phpmyadmin &> /dev/null
			rm phpMyAdmin-5.1.2-all-languages.zip &> /dev/null
			echo ""
			echo -e "\e[1;34m[\e[1;32m Done \e[1;34m]\e[0m"
			echo ""


		
	else
		echo ""
		echo -e "\e[1;34m[\e[\e[1;92m~\e[1;34m]\e[1;92Downloading phpMyAdmin-5.1.2-all-languages\e[0m"
		cd $PREFIX/share
		wget https://files.phpmyadmin.net/phpMyAdmin/5.1.2/phpMyAdmin-5.1.2-all-languages.zip
		unzip phpMyAdmin-5.1.2-all-languages.zip
		clear
		mv phpMyAdmin-5.1.2-all-languages phpmyadmin 
		ln -s $PREFIX/etc/phpmyadmin/config.inc.php $PREFIX/share/phpmyadmin &> /dev/null
		rm phpMyAdmin-5.1.2-all-languages.zip
		echo ""
		echo -e "\e[1;34m[\e[1;32m Done \e[1;34m]\e[0m"
		echo ""
	fi

}

Tamp()
{
	if [[ -f $PREFIX/bin/tamp ]]; then
		check_Packages
		pkg
		phpMyAdmin
	else
		echo -e "\e[1;31m Tamp is not installed \e[0m"
		exit 1
	fi
}
pkg() 
{
for i in wget unzip; do
	dpkg -s $i &> /dev/null
	if [[ $? -eq 0 ]]; then
		echo ""
	else
		echo -e "\e[1;34m[\e[\e[1;92m+\e[1;34m]\e[1;34m Installing $i.....\e[0m"
		apt install wget unzip -y &> /dev/null
		echo -e "\e[1;34m[\e[\e[1;92m Done \e[1;34m]\e[0m"
	fi
done
}
Tamp


