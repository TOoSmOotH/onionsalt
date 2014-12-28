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

# Create the symlink to replicate /etc/nsm/rules/

/opt/onionsalt/salt/sensor/rules:
   file.symlink:
     - target: /etc/nsm/rules

# Create the symlink to replicate /usr/local/lib/snort_dynamicrules/

/opt/onionsalt/salt/sensor/snort_dynamicrules:
   file.symlink:
     - target: /usr/local/lib/snort_dynamicrules/

# Create directory for Bro intel feeds

brointel:
   file.directory:
     - name: /opt/bro/share/bro/intel
     - makedirs: True

# Create directory for syncing Bro stuff

brosync:
   file.directory:   
     - name: /opt/onionsalt/salt/sensor/bro
     - makedirs: True

# Create the symlink for syncing Bro policy scripts

bropolicysync:
   file.symlink:
      - name: /opt/onionsalt/salt/sensor/bro/policy
      - target: /opt/bro/share/bro/policy
      
# Create the symlink for Bro intel to be synced

brointelsync:
   file.symlink:
      - name: /opt/onionsalt/salt/sensor/bro/intel
      - target: /opt/bro/share/bro/intel
      
# Create the symlink to manage Bro stuff easier

easyrules:
    file.symlink:
       - name: /etc/nsm/rules/bro
       - target: /opt/bro/share/bro/policy

# Create the symlink for OSSEC rules to be synced

ossec-rules:
   file.symlink:
       - name: /opt/onionsalt/salt/sensor/ossec-rules
       - target: /var/ossec/rules

# Create the symlink for OSSEC config to be synced
 
ossec-etc:
   file.symlink:
       - name: /opt/onionsalt/salt/sensor/ossec-etc
       - target: /var/ossec/etc

# Create /var/ossec/etc/shared/agent.conf if it doesn't already exist

ossec-agent-conf:
   file.managed:
       - name: /var/ossec/etc/shared/agent.conf
       - user: root
       - group: ossec

# Create /var/ossec/etc/local_decoder.xml if it doesn't already exist

ossec-local-decoder:
   file.managed:
       - name: /var/ossec/etc/local_decoder.xml
       - user: root
       - group: ossec

# Create the cron for the back end to check in.

backendcron:
    file.managed:
       - name: /etc/cron.d/salt-update
       - source: salt://backend/cron/salt-update
