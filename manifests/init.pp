# == Class: hierassh
#
# Manages sshd_config file and ssh service.
# Requires Puppet >= 2.7, tested with 3.x
#
# === Examples
#
#  include hierassh
#  + hiera:
#  ssh::params::running: true
#  ssh::params::config:
#    Port:
#      - 10022
#      - 22
#    X11Forwarding: 'yes'
#    UseDNS: 'no'
# 
#    On Augeas 1.2 Use:
#    Ciphers:
#      - aes128-ctr
#      - aes192-ctr
#
#    On old augeas use:
#    Ciphers: 'aes128-ctr,aes192-ctr'
#    
#
# === Authors
#
# Author Tomasz Fortuna <bla@thera.be>
#
# === Copyright
#
# Copyright 2014-2015 Tomasz Fortuna
#
class hierassh (
  $config  = $hierassh::params::config,
  $running = $hierassh::params::running,
) inherits hierassh::params {
  $keys = keys($config)

  ##
  # Basics
  ##
  $running_ensure = $running ? { true => 'running', false => 'stopped' }

  package { $params::package_name:
    notify => Anchor['sshd_config_changed'],
  }

  service { $params::service_name:
    ensure    => $running_ensure,
    enable    => $running,
    subscribe => Anchor['sshd_config_changed'],
  }

  ##
  # Config
  ##
  # Creates line-resource per each entry in hiera - rest is not managed
  sshd_config_line { $keys:
    config => $ssh::params::config
  }

  anchor { 'sshd_config_changed': }
}

# Inner definition which manages single entry in the config file
define sshd_config_line (
  $config = {}
) {
  # Extract interesting variables
  $option = $name
  $value  = $config[$name]

  if is_array($value) {
    # Generate array configuring the value using a template

    if $option in ['Port'] {
      # Multiple options
      $multiple = true
    } else {
      # Multiple arguments
      $multiple = false
    }

    augeas { "sshd ${option} = []":
      context => '/files/etc/ssh/sshd_config',
      changes => template('ssh/ssh_augeas.erb'),
    }

  } else {
    # Handle `nil' value by removing option
    $operation = $value ? {
      nil     => "rm ${option}",
      default => "set ${option} ${value}",
    }

    # Make sure it's the only entry for not-[1] iterated values
    #if $option !~ /.*\[[0-9]+\]$/ {
    #  augeas { "clear sshd ${option} = ${value}":
    #    context => '/files/etc/ssh/sshd_config',
    #    changes => "rm ${option}",
    #    onlyif  => "match ${option} size > 1",
    #  }
    #}

    augeas { "sshd ${option} = ${value}":
      context => '/files/etc/ssh/sshd_config',
      changes => $operation,
    }
  }
}
