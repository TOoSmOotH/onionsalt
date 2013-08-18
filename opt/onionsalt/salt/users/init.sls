############################
##                        ##
##     Users ini.sls      ##
##                        ##
############################

# Build the array from the pillar
{% for username, userdata in pillar.get('users', {}).iteritems() %}
{{ username }}:
  user:
    - present
{% for key, val in userdata.iteritems() %}
    - {{ key }}: {{ val }}
{% endfor %}

# This should work but it isn't which is junky 
#ssh.keys.{{ username }}:
#    ssh_auth:
#       - present
#       - user: {{ username }}
#       - source: salt://users/keys/{{ username }}.id_rsa.pub
#       - require:
#         - user: {{ username }}
#

# Enter a ghetto ass hack

# Create the .ssh directory so we can put the key in there
ssh.keydir.{{ username }}:
     file:
         - directory
         - name: /home/{{ username }}/.ssh
         - user: {{ username }}
         - group: {{ username }}
         - mode: 700

# Now create the key from the file you creates in the /srv/salt/users/keys 
/home/{{ username }}/.ssh/authorized_keys:
    file.managed:
       - source: salt://users/keys/{{ username }}.id_rsa.pub
       - mode: 600
       - user: {{ username }}
       - group: {{ username }}
{% endfor %}
