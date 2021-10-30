#!/bin/bash

function isDebian
{
	os_release=$(cat /etc/os-release | egrep "Debian")
	if [ -n "${os_release}" ]
	then
		echo 1
		return
	fi
	echo 0
}
