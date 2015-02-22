# Parameters for SSH class
class hierassh::params (
#  $config_arg  = hiera_hash('ssh::params::config'),
#  $running_arg = hiera('ssh::params::running'),
) {
  # $config is taken from hiera
  $config  = hiera_hash('hierassh::params::config')
  $running = hiera('hierassh::params::running')

  case $::osfamily {
    'Debian': {
      $package_name = 'openssh-server'
      $service_name = 'ssh'
    }

    'Redhat': {
      $package_name = 'openssh-server'
      $service_name = 'sshd'
    }

    default: {
      fail("System family ${::osfamily} not supported - update hierassh/params.pp")
    }
  }
}
