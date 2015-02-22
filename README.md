#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with ssh](#setup)
    * [What ssh affects](#what-ssh-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with ssh](#beginning-with-ssh)

## Overview

Governs contents of sshd\_config including multiple choice options like Port and
AllowUsers. Allows to alter only certain option while leaving other untouched. 
Replaces options at their place, doesn't override whole file.


TODO: I made it work with Puppet 2.7, but options in parms file could be
improved.
TODO: Ciphers option depends on augeas version. Either use list or
'ciperh1,cipher2' string.

## Module Description

You need to include hierassh module and define hiera variable
hierassh::parms::running: true

and 

  hierassh::parms::config:
    Port:
      - 22
      - 20022
    X11Forwarding: 'yes'

etc. Then using hiera inheritance you can alter some options for specific nodes
instead of using templates.

## Setup

### What ssh affects

* sshd\_config

### Setup Requirements **OPTIONAL**

Requires stdlib.

### Beginning with ssh

    ex.:
    hierassh::params::config:
      #ListenAddress: '0.0.0.0'
    
      UsePrivilegeSeparation: 'yes'
    
      # Authentication:
      LoginGraceTime: '120'
      PermitRootLogin: 'without-password'
      StrictModes: 'yes'
    
      # Other
      RSAAuthentication: 'yes'
      PubkeyAuthentication: 'yes'
      IgnoreRhosts: 'yes'
      RhostsRSAAuthentication: 'no'
      HostbasedAuthentication: 'no'
      IgnoreUserKnownHosts: 'yes'
      PermitEmptyPasswords: 'no'
      ChallengeResponseAuthentication: 'no'
      UsePAM: 'yes'
      UseDNS: 'no'
    
      # Change to no to disable tunnelled clear text passwords
      #PasswordAuthentication: yes
    
      X11Forwarding: 'yes'
      X11DisplayOffset: '10'
      PrintMotd: 'no'
      PrintLastLog: 'yes'
      TCPKeepAlive: 'yes'
    
      MaxStartups: '20:40:60'
      #Banner: '/etc/issue.net'
    
      # For new augeas (1.2.x), for old version use string.
      Ciphers: 
        - aes128-ctr
        - aes192-ctr
        - aes256-ctr


