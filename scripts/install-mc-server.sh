#!/bin/bash

# install dependencies
sudo apt update
sudo apt install curl openjdk-17-jre-headless openjdk-17-jdk-headless

server_dir=server
mkdir -p ${server_dir}
pushd ${server_dir}

# download minecraft server program
mc_server_jar_url=https://launcher.mojang.com/v1/objects/125e5adf40c659fd3bce3e66e67a16bb49ecc1b9/server.jar
mc_server_file=minecraft_server.jar
curl -L ${mc_server_jar_url} -o ${mc_server_file}

# initialize required files
java -jar ${mc_server_file} --nogui --initSettings

# accept eula
eula_content=$(cat eula.txt)
sed -i 's/eula=false/eula=true/' eula.txt

# enable whitelist on server
read -p "Would you like to enforce a whitelist? [Y/n]" enforce_whitelist
enforce_whitelist=$(echo ${enforce_whitelist} | tr '[:upper:]' '[:lower:]')
if [ -z "${enforce_whitelist}" ] || [ "${enforce_whitelist}" = "y" ]
then
	sed -i 's/enforce-whitelist=false/enforce-whitelist=true/' server.properties
	echo whitelist enabled
else
	echo whitelist declined
fi

# run some minecraft server commands
server_cmds=""
server_admin="b"
while [ -n "${server_admin}" ]
do
	read -p "add server admin (leave blank if done): " server_admin
	if [ -n "${server_admin}" ]
	then
		server_cmds+="/op ${server_admin}\n"
		server_cmds+="/whitelist add ${server_admin}\n"
	fi
done
server_cmds+="/stop\n"				# stop the server
printf "${server_cmds}" | java -jar ${mc_server_file} --nogui

read -p "How much RAM (e.g. 1G, 512M) should the server use? " reserved_ram
echo "${reserved_ram}" > ram

popd
