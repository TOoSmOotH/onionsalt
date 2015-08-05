#########################################
##                                     ##
## Salt Stuff for Critical Stack Stuff ##
##                                     ##
#########################################

# Run the install script.

cstackinstalled:
  cmd.script:
    - source: salt://scripts/cstackinstall.sh
    - shell: /bin/bash
    - cwd: /root/

cstackservice:
  service:
    - name: critical-stack-intel
    - running
    - enable: true
