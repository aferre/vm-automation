vm-automation
=============

Automate startup and shutdown of vmware virtual machines using vmrun

Install instructions:

git clone git://github.com/aferre/vm-automation.git
cd vm-automation
sudo ./install.sh

Done!

Configuration
=============

TO modify the directory where the virtual machines are stored, use the VMS_DIR variable in vm-automation.sh.

Usage
=====

vm-automation startAll/stopAll

Will start/stop all vms in VMS_DIR

vm-automation start/stop Jenkins

Will start/stop Jenkins.vmx virtual machine located in VMS_DIR

vm-automation start/stop /<Some_path>/Jenkins.vmx

Will start/stop /<Some_path>/Jenkins.vmx virtual machine
