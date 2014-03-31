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

/etc/nsm/rules:
   file.recurse:
     # Don't mess with maxdepth or you will go on a recursed loop of pain
     - maxdepth: 0
     - source: salt://sensor/rules

restart-ids:
  cmd.wait:
    - name: /usr/sbin/nsm_sensor_ps-restart --only-snort-alert
    - cwd: /
    - watch:
      - file: /etc/nsm/rules
      
restart-barnyard:
  cmd.wait:
    - name: /usr/sbin/nsm_sensor_ps-restart --only-barnyard2
    - cwd: /
    - watch:
      - file: /etc/nsm/rules
      
# Sync Bro Rules
/opt/bro/share/bro/policy:
    file.recurse:
       - source: salt://sensor/bro/policy

restart-bro:
  cmd.wait:
    - name: /opt/bro/bin/broctl install; /opt/bro/bin/broctl restart
    - cwd: /
    - watch:
      - file: /opt/bro/share/bro/policy

# Watch the OSSEC local_rules.xml file and restart when needed

/var/ossec/rules:
  file.recurse:
    - maxdepth: 0
    - source: salt://sensor/ossec

restart-ossec:
  cmd.wait:
    - name: service ossec-hids-server restart
    - cwd: /
    - watch:
      - file: /var/ossec/rules
      
# Get rid of the old cron job that updates rules because we don't need it any more

/etc/cron.d/rule-update:
   file.absent

# Put our new cron job up in there

/etc/cron.d/salt-update:
    file.managed:
       - source: salt://sensor/cron/salt-update
