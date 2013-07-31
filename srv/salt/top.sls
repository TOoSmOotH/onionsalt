#########################
##                     ##
##      Salt top.sls   ##
##                     ##
#########################

base:

# This is all servers so that your user accounts and the proper sudo modifications so you don't need a password.
   '*':
      - users
      - sudo

# This is your sensors. It is a good idea to have a standard naming convention so here are a few examples:
#
#  'sensor*':
#    - sensor
#
# or you can do this:
#    'server1,server2':
#       - match: list
#       - sensor
#
# or this:
#   'server* or sensor*
#       - match: compound    
#       - sensor

# My sensor class:
   'A*':
      - sensor

# My Onion Backend:
   'C*':
      - backend
     
