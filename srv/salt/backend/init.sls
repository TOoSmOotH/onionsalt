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
/srv/salt/sensor/rules:
   file.symlink:
     - target: /etc/nsm/rules
