############################
##                        ##
##   Build the Backend    ##  
##                        ##
############################

# Add the repo

backend:
  pkgrepo.managed:
    - humanname: SecurityOnion PPA
    - name: deb http://ppa.launchpad.net/securityonion/stable/ubuntu precise main
    - dist: precise
    - file: /etc/apt/sources.list.d/securityonion-stable-precise.list
    - keyid: E1E6759023F386C7
    - keyserver: keyserver.ubuntu.com
    - require_in:
       - pkg: securityonion-all

# Install all the packages

securityonion-all:
   pkg.installed

# Create the symlink for the rules files.

/opt/onionsalt/salt/sensor/rules:
   file.symlink:
     - target: /etc/nsm/rules

# Create Directory for Bro intel stuff

brointel:
   file.directory:
     - name: /opt/bro/share/intel
     - makedirs: True

# Create Bro directory for syncing stuff

brosync:
   file.directory:   
     - name: /opt/onionsalt/salt/sensor/bro
     - makedirs: True

# Create the symlink for bro rules to be synced. 

bropolicysync:
   file.symlink:
      - name: /opt/onionsalt/salt/sensor/bro/policy
      - target: /opt/bro/share/bro/policy
      
# Create the symlink for bro intel to be synced

brointelsync:
   file.symlink:
      - name: /opt/onionsalt/salt/sensor/bro/intel
      - target: /opt/bro/share/bro/intel
      
# Create the symlink to manage bro stuff easier

easyrules:
    file.symlink:
       - name: /etc/nsm/rules/bro
       - target: /opt/bro/share/bro/policy

       
# Create the symlink for OSSEC rules to be synced

ossecsync:
   file.symlink:
       - name: /opt/onionsalt/salt/sensor/ossec
       - target: /var/ossec/rules

# Create the cron for the back end to check in.

backendcron:
    file.managed:
       - name: /etc/cron.d/salt-update
       - source: salt://backend/cron/salt-update
