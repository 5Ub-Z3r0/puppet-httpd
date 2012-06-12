# Class: apache
#
# This class installs Apache HTTPd server
#
# Parameters:
#  - keepAlive: turns On (or Off) keepalive for requests (Default: On)
#  - deflate: turns On (or Off) httpd compression (Default: disabled)
#
# Actions:
#  - Install Apache
#  - Manage Apache service
#
# Requires:
#
# Sample Usage:
#
class httpd(
  $keepAlive = 'On',
  $deflate = false
) {
  include httpd::params
  package { 'httpd':
    ensure => present,
    name   => $httpd::params::httpd_name
  }
  service { 'httpd':
    ensure    => running,
    name      => $httpd::params::httpd_name,
    enable    => true,
    subscribe => Package['httpd']
  }

  A2mod { require => Package['httpd'], notify => Service['httpd']}
  @a2mod {
    'rewrite' : ensure => present;
    'headers' : ensure => present;
    'expires' : ensure => present;
  }

#  file { $httpd::params::vdir:
#    ensure  => directory,
#    recurse => true,
#    purge   => false,
#    notify  => Service['httpd'],
#  }

  #
  # Install custom configurations (varies if it's debian or rhel-like)
  #
  file { $httpd::params::config_to:
    ensure  => file,
    content => template($httpd::params::config_from),
    notify  => Service['httpd'],
  }

  #
  # If mod_deflate is enabled, copy the configuration
  #
  if $deflate == true {
    case $::operatingsystem {
      Debian, Ubuntu: {
        @a2mod {
          'deflate' : ensure => present;
        }
      }
      default: {
      }
    }
    file { $httpd::params::deflateconfig_to:
      ensure => file,
      source => $httpd::params::deflateconfig_from,
      notify => Service['httpd']
    }
  }

  #
  # Custom error pages
  #
  file { $httpd::params::errdir:
    ensure  => directory,
    recurse => true,
    purge   => false,
    source  => "puppet:///${module_name}/error",
    ignore  => '\.svn',
    notify  => Service['httpd']
  }

}
