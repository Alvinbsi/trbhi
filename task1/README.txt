Prerequisites
You need:

Terraform for your platform. Detailed install instruction at Terraform Install
	1.curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
	2.sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
	3.sudo apt update
	4.sudo apt install terraform
The project should work on any cloud, but we've tested it on AZURE so far.

AZURE CLI Installation
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

IF testing on AZURE:

An AZURE account, configured with the cli locally
	1. az login

Automated Provisioning
	1. Download task1 from github(https://github.com/Alvinbsi/trbhi.git)
	Run below commands inside of the task1 directory
		1. terraform init
		2. terraform plan
		3. terraform apply

Server Login Credentials:
	1. username : testadmin
	2. password : Password1234!

==========================================================================================

Script:

1. Add valid hosts ip address into host_list.txt
2. Run cpu_disk_usage.sh (sh cpu_disk_usage.sh)
3. check the 'output' file it creates while executing cpu_disk_usage.sh file


