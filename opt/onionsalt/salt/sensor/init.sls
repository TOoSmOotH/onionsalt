###################
##               ##
##  Sensor SLS   ##
##               ##
###################

# Add the Repo
sensor:
  pkgrepo.managed:
    - humanname: SecurityOnion PPA
    - name: deb http://ppa.launchpad.net/securityonion/stable/ubuntu precise main
    - dist: precise
    - file: /etc/apt/sources.list.d/securityonion-stable-precise.list
    - keyid: E1E6759023F386C7
    - keyserver: keyserver.ubuntu.com
    - require_in:
       - pkg: securityonion-sensor

# Install the packages

securityonion-sensor:
   pkg.installed

# Watch the Rules and restart when needed

nsm-sensor:
  service.running:
     - watch: 
        - file: /etc/nsm/rules

/etc/nsm/rules:
   file.recurse:
     # Don't mess with maxdepth or you will go on a recursed loop of pain
     - maxdepth: 0
     - source: salt://sensor/rules

# Sync Bro Rules
/opt/bro/share/bro/policy:
    file.recurse:
       - source: salt://sensor/bro/policy
    
# Get rid of the old cron job that updates rules because we don't need it any more

/etc/cron.d/rule-update:
   file.absent

# Put our new cron job up in there

/etc/cron.d/salt-update:
    file.managed:
       - source: salt://sensor/cron/salt-update
