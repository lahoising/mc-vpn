#!/bin/bash

hamachi_out_dir="vpn"
mkdir -p "${hamachi_out_dir}"
pushd "${hamachi_out_dir}"

# uninstall hamachi if it is already installed
if [ -n "$(which hamachi)" ]
then
	sudo dpkg --purge logmein-hamachi
fi

hamachi_url="https://www.vpn.net/installers/logmein-hamachi_2.1.0.203-1_amd64.deb"
hamachi_out_installer_file="hamachi_ins.deb"
curl -L "${hamachi_url}" -o "${hamachi_out_installer_file}"
sudo dpkg -i "${hamachi_out_installer_file}"
rm "${hamachi_out_installer_file}"

sleep 5s
sudo hamachi login
read -p "Hamachi email: " hamachi_email
sudo hamachi attach "${hamachi_email}"
read -p "Prefered nickname: " hamachi_nickname
sudo hamachi set-nick "${hamachi_nickname}"
read -p "Hamachi network id: " hamachi_net_id
sudo hamachi do-join "${hamachi_net_id}"

echo "${hamachi_net_id}" > netid

popd
