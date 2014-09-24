OnionSalt
=========

Welcome to the OnionSalt git repo. OnionSalt is a tool created to manage multiple Security Onion sensors. 

Changelog:

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

