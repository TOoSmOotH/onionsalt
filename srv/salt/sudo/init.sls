###########################
##                       ##
##     Sudo init.sls     ##
##                       ##
###########################

# Make it so the sudo group can run sudo commands without a password since we are using key auth
/etc/sudoers:
  file.append:
    - text: "%sudo ALL=(ALL) NOPASSWD: ALL"
