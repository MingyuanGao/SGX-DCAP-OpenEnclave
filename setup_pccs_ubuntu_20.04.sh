#!/bin/bash

# https://software.intel.com/content/www/us/en/develop/articles/intel-software-guard-extensions-data-center-attestation-primitives-quick-install-guide.html
# https://github.com/openenclave/openenclave/blob/master/docs/GettingStartedDocs/Contributors/NonAccMachineSGXLinuxGettingStarted.md

curl -o setup.sh -sL https://deb.nodesource.com/setup_14.x
chmod +x setup.sh
sudo ./setup.sh

sudo apt -y update
sudo apt -y install nodejs
rm setup.sh

echo 'deb [arch=amd64] https://download.01.org/intel-sgx/sgx_repo/ubuntu focal main' | sudo tee /etc/apt/sources.list.d/intel-sgx.list
wget -O - https://download.01.org/intel-sgx/sgx_repo/ubuntu/intel-sgx-deb.key | apt-key add -
sudo apt update -y
sudo apt install -y sqlite3 python build-essential
sudo apt install -y sgx-dcap-pccs

echo -e "\nNOTE: \nConfiguration file for PCCS is:"
echo -e "    /opt/intel/sgx-dcap-pccs/config/default.json"
echo -e "To purge PCCS, run $ sudo apt purge sgx-dcap-pccs"
echo -e "To check the status of PCCS, run $ sudo systemctl status pccs"

echo -e "Currently, PCCS does not work with Open Enclave due to a small bug, comment "
echo -e "result['pckcrl'] = Buffer.from(result['pckcrl'], 'utf8').toString('hex'); in /opt/intel/sgx-dcap-pccs/services/pckcrlService.js"
echo -e "crl = Buffer.from(crl, 'utf8').toString('hex'); in /opt/intel/sgx-dcap-pccs/services/rootcacrlService.js" 
