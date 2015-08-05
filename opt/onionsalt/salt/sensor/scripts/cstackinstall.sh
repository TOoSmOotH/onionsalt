###
## Script for Critical Stack Intel Client install
##

# Check for the drop....
if [ ! -f /etc/state/cstack.txt ]; then
curl https://packagecloud.io/install/repositories/criticalstack/critical-stack-intel/script.deb.sh | bash
sudo apt-get install critical-stack-intel
touch /etc/state/cstack.txt
fi
