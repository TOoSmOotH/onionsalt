#######################
##                   ##
##  Pillar top.sls   ## 
##                   ##
#######################

# Pull the hostname grain
{% set hostn = salt['grains.get']('host', '') %}

# You shouldn't have to mess with this.

base:
  '*':
    - users
#    - sensors.{{ hostn }}
