#!/usr/bin/env bash

option="${1}" 
case ${option} in 
   -start) 
	   if ps -C httpd >/dev/null; then
		   echo "apache2 service still running..."
	   else

	   spinner=( '█■■■■' '■█■■■' '■■█■■' '■■■█■' '■■■■█' )

		for i in "${spinner[@]}"
		do
        		echo -ne "\033[1;34m\r[\e[1;31m*\e[1;34m] Starting Tamp Server.....\e[34m[\033[31m$i\033[34m]\033[0m   ";
       			sleep .30s
			printf "\b\b\b\b\b\b\b\b";
		done
		httpd &> /dev/null
		mysqld --skip-grant-tables --general-log &> /dev/null
		printf "   \b\b\b\b\b"
		printf "\e[1;34m[\e[1;32m Done \e[1;34m]\e[0m";
		echo "";
	   fi
      ;; 
   -stop)
	   spinner=( '█■■■■' '■█■■■' '■■█■■' '■■■█■' '■■■■█' )
	   for i in "${spinner[@]}"
	   do
		   echo -ne "\033[1;34m\r[\e[1;31m*\e[1;34m] Stopping Tamp Server.....\e[34m[\033[31m$i\033[34m]\033[0m   ";
		   sleep .30s
		   printf "\b\b\b\b\b\b\b\b";
	   done
	   h=`pgrep httpd`
	   kill -9 $h &>/dev/null
	   m=`pgrep mysqld`
	   kill -9 $m &>/dev/null
	   printf "   \b\b\b\b\b"
	   printf "\e[1;34m[\e[1;32m Done \e[1;34m]\e[0m";
	   echo "";

      ;;

     -h)
	echo ""
	echo -e "\e[1;38;5;29m<═══════════════ Tamp Commands ═══════════════>\e[0m"
	echo ""
	echo -e "\e[1;38;5;29mtamp -start  \e[1;38;5;198mTo Start\e[0m"
	echo -e "\e[1;38;5;29mtamp -stop   \e[1;38;5;198mTo Stop\e[0m"
	echo -e "\e[1;38;5;29mtamp -r      \e[1;38;5;198mTo Restart\e[0m"
	echo -e "\e[1;38;5;29mtamp -dc     \e[1;38;5;198mTo Change Document Root\e[0m"
	echo -e "\e[1;38;5;29mtamp -df     \e[1;38;5;198mTo Set Document Root as Default\e[0m"
	echo -e "\e[1;38;5;29mtamp -log    \e[1;38;5;198mTo Check http Access & Error logs"
	echo -e "\e[1;38;5;29mtamp -clog   \e[1;38;5;198mTo Clear log history"
	echo -e "\e[1;38;5;29mtamp -un     \e[1;38;5;198mTo Uninstall Tamp Server\e[0m"
	echo -e "\e[1;38;5;29mtamp -v      \e[1;38;5;198mTo check Tamp version\e[0m"
	echo -e "\e[1;38;5;29mtamp -h      \e[1;38;5;198mFor help\e[0m"
      ;;

    -df)
	PATH1="/data/data/com.termux/files/usr/share/Tamp"
	PATH2="/data/data/com.termux/files/usr/share/Tamp/CONF_FILE"
	PATH3="/data/data/com.termux/files/usr/etc/apache2"
	PATH4="/data/data/com.termux/files/usr/etc/apache2/extra"
	DF_PATH="/data/data/com.termux/files/usr/share/apache2/default-site/htdocs"
	cp $PATH2/httpd.conf $PATH1
	cp $PATH2/httpd-vhosts.conf $PATH1
	sed -i $'s+dc_path_manual+'$DF_PATH'+g' $PATH1/httpd.conf
	sed -i $'s+dc_path_manual+'$DF_PATH'+g' $PATH1/httpd-vhosts.conf
	mv $PATH1/httpd.conf $PATH3
	mv $PATH1/httpd-vhosts.conf $PATH4
	printf "\e[1;32mSuccessfully changed to default\e[0m\n"
      ;;
      
    -dc)
	PATH1="/data/data/com.termux/files/usr/share/Tamp"
	PATH2="/data/data/com.termux/files/usr/share/Tamp/CONF_FILE"
	PATH3="/data/data/com.termux/files/usr/etc/apache2"
	PATH4="/data/data/com.termux/files/usr/etc/apache2/extra"
	cp $PATH2/httpd.conf $PATH1
	cp $PATH2/httpd-vhosts.conf $PATH1
	read -p $'\n\e[1;34m[\e[1;32m+\e[1;34m]Enter New Document Root Path\e[1;31m:- \e[0m' dc_path
	sed -i 's+dc_path_manual+'$dc_path'+g' $PATH1/httpd.conf
	sed -i 's+dc_path_manual+'$dc_path'+g' $PATH1/httpd-vhosts.conf
	mv $PATH1/httpd.conf $PATH3
	mv $PATH1/httpd-vhosts.conf $PATH4
	printf "\e[1;32mSuccessfully changed\e[0m\n"
      ;;
     -un)
	     LOG_PATH="/data/data/com.termux/files/usr/var/log/apache2"
	     choice=""
	     printf "\e[1;34mDo you want uninstall Tamp web server[\e[1;31my/n\e[1;34m]\e[0m:- "
	     read choice
	     if [[ "${choice}" = "y" ]] || [[ "${choice}" = "Y" ]]; then
		     echo -e "\e[1;34m[\e[1;31m~\e[1;34m]\e[1;31m Uninstalling Tamp web server.....\e[0m"
		     for i in apache2 mariadb php php-apache phpmyadmin; do
			     dpkg -s $i &>/dev/null
			     echo -e "\e[1;0mUninstalling \e[1;31m$i"
			     apt purge $i -y &>/dev/null
		     done
		     apt autoremove -y &>/dev/null
		     echo -e "\e[1;34m[\e[1;31m~\e[1;34m]\e[1;31mRemoving Tamp directories & Files...\e[0m"
		     rm -rf /data/data/com.termux/files/usr/share/Tamp
		     rm /data/data/com.termux/files/usr/bin/tamp
		     rm $LOG_PATH/localhost_Access_log
		     rm $LOG_PATH/localhost_Error_log
		     rm $LOG_PATH//phpmyadmin_Access_log
		     rm $LOG_PATH/phpmyadmin_Error_log
		     echo -e "\e[1;34m[\e[1;32m Done \e[1;34m]\e[0m"
	     elif [[ "${choice}" = "n" ]] || [[ "${choice}" = "N" ]]; then
		     exit 0 
	     else
		     echo -e "\e[1;31m Wrong input !\e[0m"
	     fi
      ;;
     -r)
	spinner=( '█■■■■' '■█■■■' '■■█■■' '■■■█■' '■■■■█' )
	for i in "${spinner[@]}"
	do
	echo -ne  "\033[1;34m\r[\e[1;31m*\e[1;34m] Restarting Tamp Server.....\e[34m[\033[31m$i\033[34m]\033[0m   ";
	sleep .30s
	printf "\b\b\b\b\b\b\b\b";
        done
	h=`pgrep httpd`
	kill -9 $h &>/dev/null
	m=`pgrep mysqld`
	kill -9 $m &>/dev/null
	if [[ -f /data/data/com.termux/files/usr/var/run/apache2/httpd.pid ]]; then
		rm /data/data/com.termux/files/usr/var/run/apache2/httpd.pid
		httpd &> /dev/null
		mysqld --skip-grant-tables --general-log &> /dev/null
	else
		httpd &> /dev/null
		mysqld --skip-grant-tables --general-log &> /dev/null
	fi
	if [[ -e /data/data/com.termux/files/usr/var/lib/mysql/ib_logfile0 ]]; then
		rm /data/data/com.termux/files/usr/var/lib/mysql/ib_logfile0
	else
		echo "no ib_logfile0 found in var/lib/mysql"
	fi
	if ps -C mysqld &> /dev/null; then
		echo "mysqld is running"
	else 
		mysqld_safe --skip-grant-tables --general-log &> /dev/null
	fi
	printf "   \b\b\b\b\b"
	printf "\e[1;34m[\e[1;32m Done \e[1;34m]\e[0m";
	echo ""
      ;;
      -log)
	      LOG_PATH="/data/data/com.termux/files/usr/var/log/apache2"
	      cd $LOG_PATH
	      watch tail localhost_Access_log localhost_Error_log phpmyadmin_Access_log phpmyadmin_Error_log
	      cd $HOME
      ;;
     -clog)
	     LOG_PATH="/data/data/com.termux/files/usr/var/log/apache2"
	     if [[ -e $LOG_PATH/localhost_Access_log ]]; then
		     rm $LOG_PATH/localhost_Access_log
		     touch $LOG_PATH/localhost_Access_log
	     else
		     touch $LOG_PATH/localhost_Access_log
	     fi
	     if [[ -e $LOG_PATH/localhost_Error_log ]]; then
		     rm $LOG_PATH/localhost_Error_log
		     touch $LOG_PATH/localhost_Error_log
	     else
		     touch $LOG_PATH/localhost_Error_log
	     fi
	     if [[ -e $LOG_PATH/phpmyadmin_Access_log ]]; then
		     rm $LOG_PATH/phpmyadmin_Access_log
		     touch $LOG_PATH/phpmyadmin_Access_log
	     else
		     touch $LOG_PATH/phpmyadmin_Access_log
	     fi
	     if [[ -e $LOG_PATH/phpmyadmin_Errot_log ]]; then
		     rm $LOG_PATH/phpmyadmin_Errot_log
		     touch $LOG_PATH/phpmyadmin_Errot_log
	     else
		     touch $LOG_PATH/phpmyadmin_Errot_log
	     fi
	     printf "\e[1;32mLog Files cleared successfully\e[0m\n"

      ;;
    -v)
	    echo "Tamp 1.0 (Webserver) ( built july 27, 2021 )"
	    echo "Copyright (c) techx"
     ;;
   *)  
      echo -e "`basename ${0}`:usage\e[38;5;198m:\e[0m tamp \e[38;1;198m-options\e[0m\ntry\e[38;5;198m:\e[0m tamp \e[38;5;198m-h\e[0m for help" 
      exit 1 # Command to come out of the program with status 1
      ;; 
esac
#ib_logfile0
