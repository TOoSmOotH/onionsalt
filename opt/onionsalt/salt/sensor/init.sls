###################
##               ##
##  Sensor SLS   ##
##               ##
###################

# Uncomment to enable central bpf_configuration. Be sure to read ./bpf/init.slt
#include:
#- .bpf

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

## End IDS Section

## Begin Bro Section ##

# Sync Bro Rules

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

/opt/bro/share/bro/site/local.bro:
  file.blockreplace:
    - marker_start: "# Begin Onionsalt Awesomeness.. If you edit this do so on the Onionsalt master"
    - marker_end: "# DONE Onionsalt Awesomeness"
    - content: |
         @load policy/frameworks/intel/seen
         @load frameworks/intel/do_notice
         redef Intel::read_files += {
                 "/opt/bro/share/bro/intel/YOURINTELFILE.intel"
         };
    - show_changes: True
    - append_if_not_found: True
	  restart-bro:
    cmd.wait:
      - name: /opt/bro/bin/broctl stop && sleep 30 && /opt/bro/bin/broctl install && sleep 20 && /opt/bro/bin/broctl start
      - cwd: /
      - watch:
      - file: /opt/bro/share/bro/policy
      - file: /opt/bro/share/bro/intel
      - file: /opt/bro/share/bro/site

## End Bro Section ##

## Begin OSSEC Section ##

# Watch the OSSEC local_rules.xml file and restart when needed

ossec-sync:
  file.recurse:
    - name: /var/ossec/rules
    - maxdepth: 0
    - source: salt://sensor/ossec

restart-ossec:
  cmd.wait:
    - name: service ossec-hids-server restart
    - cwd: /
    - watch:
      - file: /var/ossec/rules
      
## End OSSEC Section ##
# Get rid of the old cron job that updates rules because we don't need it any more

/etc/cron.d/rule-update:
   file.absent

# Put our new cron job up in there

cron-update-salt-checkin:
    file.managed:
       - name: /etc/cron.d/salt-update
       - source: salt://sensor/cron/salt-update
