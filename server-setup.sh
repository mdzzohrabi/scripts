#!/usr/bin/env bash

# This script built for ease of server setup
# @author Masoud Zohrabi <mdzzohrabi@gmail.com>

# Script version
v="0.1"

echo "Masoud Server setup script v${v}"
echo ""

# Check linux
if [[ ! "$(uname)" = "Linux" ]]; then
	echo "Error: This script built for Linux"
	exit 1
fi

# Get linux dist name
osName=`lsb_release -si`

# Check CentOS
if [[ "$osName" != "CentOS" ]]; then
	echo "Error : This script built for CentOS"
	exit 1
fi

# Yes/No Prompt
function prompt {
	read -n 1 -ers -p "$1 [Y/n]" ret
	if [[ "$ret" != "n" && "$ret" != "N" ]]; then
		echo 1
	else
		echo 0
	fi
	return 1
}

# MySQL
mdzzohrabi_mysql() {

	[ $(prompt "Do you want to install MySQL ?") -eq 0 ] && return 0

	# Install MySQL
	which mysql > /dev/null
	err=$?; if [ "$err" -ne 0 ]; then
		echo "Installing MySQL ..."
		sudo yum install mysql-server
	else
		echo "MySQL already installed."
	fi

	# Start MySQL
	service mysqld status > /dev/null
	if [ "$?" -ne 0 ]; then
		echo "Start MySQL Service..."
		sudo service mysqld start
	else
		echo "MySQL is running."
	fi

	# Configuration
	if [ `prompt "Do you want to configure mysql ?"` -eq 1 ]; then
		sudo mysql_install_db
		sudo mysql_secure_installation
	fi

}

# Nginx
mdzzohrabi_nginx() {
	[ `prompt "Do you want to install Nginx ?"` -eq 0 ] && return 0

	sudo yum install nginx
}

mdzzohrabi_git() {
	[ `prompt "Do you want to install Git ?"` -eq 0 ] && return 0

	sudo yum install git
}

mdzzohrabi_mysql
mdzzohrabi_nginx
mdzzohrabi_git
mdzzohrabi_php
