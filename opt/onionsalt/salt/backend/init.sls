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

# Create the symlink for bro rules to be synced. 

/opt/onionsalt/salt/sensor/bro/policy:
   file.symlink:
      - target: /opt/bro/share/bro/policy
      - require:
        - file.directory: /srv/salt/sensor/bro

/opt/onionsalt/salt/sensor/bro:
      file.directory:
        - makedirs: True

# Create the symlink to manage bro stuff easier

/etc/nsm/rules/bro:
    file.symlink:
       - target: /opt/bro/share/bro/policy
       
# Create the symlink for OSSEC rules to be synced

/opt/onionsalt/salt/sensor/ossec:
   file.symlink:
      - target: /var/ossec/rules

# Create the cron for the back end to check in.

/etc/cron.d/salt-update:
    file.managed:
       - source: salt://backend/cron/salt-update
