# Setting up Intel SGX DCAP Attestation Service and Open Enclave SDK at On-Premise Datacenters

This guide documents how to set up the Intel SGX Data Center Attestation Primitives (DCAP)-based attestation service on Ubuntu 20.04_amd64 at a local cluster, with support for the Open Enclave SDK.

References:

1. https://software.intel.com/content/www/us/en/develop/articles/intel-software-guard-extensions-data-center-attestation-primitives-quick-install-guide.html
2. https://github.com/openenclave/openenclave/blob/master/docs/GettingStartedDocs/Contributors/NonAccMachineSGXLinuxGettingStarted.md

## Setting up Intel Provisioning Certificate Caching Service (PCCS)

### Subscribe to the Intel PCS
Please refer to the “Subscribe to the Intel PCS” in *Reference 1*.

### Setup the Intel PCCS
Please refer to the “Setup the Intel PCCS” in *Reference 1*.

### Patch the Installed PCCS to support Open Enclave SDK
In /opt/intel/sgx-dcap-pccs/services/pckcrlService.js, comment below line:

`result['pckcrl'] = Buffer.from(result['pckcrl'], 'utf8').toString('hex');`

In /opt/intel/sgx-dcap-pccs/services/rootcacrlService.js, comment below line:

`crl = Buffer.from(crl, 'utf8').toString('hex');`

### Restart the PCCS service

`$ sudo systemctl restart pccs.service`

Now, a working PCCS for Open Enclave should be brought up. 

### Verify the PCCS service
Use the following command to verify if it can fetch the root CA CRL from the Intel PCK service: 

`$ curl --noproxy "*" -v -k -G https://localhost:8081/sgx/certification/v3/rootcacrl`



## Setting up Open Enclave with DCAP Support on an SGX-enabled Machine

### Install the Intel SGX DCAP Driver

> Mainline kernel release 5.11 or higher includes the SGX in-kernel driver, which requires the platform to support and to be configured for Flexible Launch Control (FLC) in BIOS.
> 
> We will use the in-kernel driver in this guide


`$ sudo apt update -y`

`$ sudo apt install -y linux-image-5.13.0-1014-oem`

`$ sudo usermod -aG sgx_prv $(whoami)`

`$ sudo update-grub`

`$ sudo reboot`



### Install the Open Enclave SDK

`$ echo 'deb [arch=amd64] https://download.01.org/intel-sgx/sgx_repo/ubuntu focal main' | sudo tee /etc/apt/sources.list.d/intel-sgx.list`

`$ wget -qO - https://download.01.org/intel-sgx/sgx_repo/ubuntu/intel-sgx-deb.key | sudo apt-key add –`

`$ echo "deb http://apt.llvm.org/focal/ llvm-toolchain-focal-10 main" | sudo tee /etc/apt/sources.list.d/llvm-toolchain-focal-10.list`

`$ wget -qO - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add –`

`$ echo "deb [arch=amd64] https://packages.microsoft.com/ubuntu/20.04/prod focal main" | sudo tee /etc/apt/sources.list.d/msprod.list`

`$ wget -qO - https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add –`

`$ sudo apt update -y`

`$ sudo apt install -y clang-10 libssl-dev gdb libprotobuf17`

`$ sudo apt install -y open-enclave`


### Setup the Intel DCAP Quote Provider Library

**Install the package**

`$ sudo apt purge -y az-dcap-client`

`$ sudo apt install -y libsgx-dcap-default-qpl`

**Create a soft link** (named `libdcap_quoteprov.so`) to `libdcap_quoteprov.so.x.yy.zzz.v`
  
`$ cd /usr/lib/x86_64-linux-gnu`

`$ sudo rm -f libdcap_quoteprov.so`

`$ sudo ln -s libdcap_quoteprov.so.1.11.101.1 libdcap_quoteprov.so`
> Make sure the version number is correct


**Configure the qpl**

In /etc/sgx_default_qcnl.conf, add the following lines:
> 	# Replace 10.0.0.80:8081 with that of the PCCS server
> 
> 	PCCS_URL=https://10.0.0.80:8081/sgx/certification/v3/
> 
> 	USE\_SECURE\_CERT=FALSE
> 

### Verify that Remote Attestation Can Work Properly 
We can use the “attestation sample” in the Open Enclave SDK to verify that remote attestation works properly.

`$ cp -r /opt/openenclave/share/openenclave/samples/attestation/ .`

`$ cd attestation/`

`$ source /opt/openenclave/share/openenclave/openenclaverc`

`$ make`

`$ make runsgxremote`

