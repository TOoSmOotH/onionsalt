###########################
##                       ##
##     Sudo init.sls     ##
##                       ##
###########################

# Make it so the sudo group can run sudo commands without a password since we are using key auth
sudoers:
  file.append:
    - name: /etc/sudoers
    - text: "%sudo ALL=(ALL) NOPASSWD: ALL"
