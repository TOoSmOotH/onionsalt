###################
##               ##
##  Sensor SLS   ##
##               ##
###################

# Uncomment to enable central bpf_configuration. Be sure to read ./bpf/init.sls
#include:
#- .bpf

# Create the state directory
statedir:
  file.directory:
    - name: /etc/state

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

## Begin IDS Section ##

# Watch the Rules and restart when needed

rule-sync:
   file.recurse:
     - name: /etc/nsm/rules
     # Don't mess with maxdepth or you will go on a recursed loop of pain
     - maxdepth: 0
     - source: salt://sensor/rules

dynamicrule-sync:
   file.recurse:
     - name: /usr/local/lib/snort_dynamicrules
     # Don't mess with maxdepth or you will go on a recursed loop of pain
     - maxdepth: 0
     - source: salt://sensor/snort_dynamicrules

restart-ids:
  cmd.wait:
    - name: /usr/sbin/nsm_sensor_ps-restart --only-snort-alert
    - cwd: /
    - watch:
      - file: /etc/nsm/rules
      - file: /usr/local/lib/snort_dynamicrules

restart-barnyard:
  cmd.wait:
    - name: /usr/sbin/nsm_sensor_ps-restart --only-barnyard2
    - cwd: /
    - watch:
      - file: /etc/nsm/rules
      - file: /usr/local/lib/snort_dynamicrules

## End IDS Section

## Begin Bro Section ##

# Sync Bro policy scripts

bro-rules-sync:
    file.recurse:
       - name: /opt/bro/share/bro/policy
       - source: salt://sensor/bro/policy

# Bro Intel Feed

bro-intel:
   file.directory:
     - name: /opt/bro/share/bro/intel
     - makedirs: True

bro-intel-sync:
    file.recurse:
       - name: /opt/bro/share/bro/intel
       - source: salt://sensor/bro/intel

# Enable the Bro Intel Framework

# Commenting out since we're doing this in securityonion-bro-scripts now
#/opt/bro/share/bro/site/local.bro:
#  file.blockreplace:
#    - marker_start: "# BEGIN Onionsalt Modications. If you edit this, do so on the Onionsalt master"
#    - marker_end: "# END Onionsalt Modifications."
#    - content: |
#         @load intel
#    - show_changes: True
#    - append_if_not_found: True

## End Bro Section ##

## Enable Critical Stack Intel Client ##

#csinstall:
#  cmd.script:
#    - source: salt://sensor/scripts
#    - shell: /bin/bash
#    - template: jinja

## End Critical Stack Intel Client


## Begin OSSEC Section ##

# Watch the OSSEC local_rules.xml file and restart when needed

ossec-rules:
  file.recurse:
    - name: /var/ossec/rules
    - maxdepth: 0
    - source: salt://sensor/ossec-rules

ossec-agent-conf:
  file.managed:
    - name: /var/ossec/etc/shared/agent.conf
    - source: salt://sensor/ossec-etc/shared/agent.conf
    - user: root
    - group: ossec

ossec-local-decoder:
  file.managed:
    - name: /var/ossec/etc/local_decoder.xml
    - source: salt://sensor/ossec-etc/local_decoder.xml
    - user: root
    - group: ossec

restart-ossec:
  cmd.wait:
    - name: service ossec-hids-server restart
    - cwd: /
    - watch:
      - file: /var/ossec/rules
      - file: /var/ossec/etc/shared/agent.conf
      - file: /var/ossec/etc/local_decoder.xml

## End OSSEC Section ##

# Get rid of the old cron job that updates rules because we don't need it any more

/etc/cron.d/rule-update:
   file.absent

# Put our new cron job up in there

cron-update-salt-checkin:
    file.managed:
       - name: /etc/cron.d/salt-update
       - source: salt://sensor/cron/salt-update
