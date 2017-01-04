OnionSalt
=========

Welcome to the OnionSalt git repo. OnionSalt is a tool created to manage multiple [Security Onion](https://github.com/Security-Onion-Solutions/security-onion) sensors.

For more details on using OnionSalt in your Security Onion deployment, please see the [Security Onion wiki](https://github.com/Security-Onion-Solutions/security-onion/wiki/Salt).

### Resources
- Mike Reeves ([TOoSmOotH](https://twitter.com/TOoSmOotH)) BSides August 2014 Talk - [Scaling Security Onion to the Enterprise](https://www.youtube.com/watch?v=hHhxVQxj3aY)
- [Security Onion Blog](http://blog.securityonion.net/) and the related [OnionSalt Blog Posts](http://blog.securityonion.net/search/label/onionsalt)

### Changelog

Version 1.1.7:

	- Migrate from Precise to Trusty
	- use /etc/sudoers.d/ instead of directly editing /etc/sudoers
	
Version 1.1.6:

	- Create /usr/local/lib/snort_dynamicrules if it doesn't already exist

Version 1.1.5:

	- Sync Snort VRT .so files from /usr/local/lib/snort_dynamicrules

Version 1.1.4:

	- Minor modification to how the bpf management gets a list of interfaces to
	  use - see opt/onionsalt/salt/sensor/bpf/init.sls

Version 1.1.3:

	- Sync OSSEC's agent.conf and local_decoder.xml
	- /opt/bro/share/bro/intel/ is now added by securityonion-bro-scripts package
	- Bro restart is now commented out by default

Version 1.1.2:
        
        - Enabled the Bro Intel Framework
        - Fixed the restart process for Bro when a policy changes
        
Version 1.1.1:

	- Renamed files from .orig to .template
	- Fixed some spelling errors in the code

Version 1.1.0:

	- Added support for latest version of Saltstack 2014.1.4
	- Adopted the new method of giving each item a - name: instead of leading with the file to manage
	- Added initial support for the Bro Intel Framework. This needs tested more so it is commented out by default

Version 1.0.0

	- Initial Release. 
