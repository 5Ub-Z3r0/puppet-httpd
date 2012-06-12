# Class: httpd::ssl
#
# This class installs Apache HTTPD SSL capabilities
#
# Parameters:
# - The $ssl_package name from the httpd::params class
#
# Actions:
#   - Install Apache HTTPD SSL capabilities
#
# Requires:
#
# Sample Usage:
#
class httpd::ssl {

  include httpd

  case $::operatingsystem {
    'centos', 'fedora', 'redhat': {
      package { $httpd::params::ssl_package:
        require => Package['httpd']
      }
      file { $httpd::params::sslconfig_to:
        ensure  => file,
        content => template($httpd::params::sslconfig_from),
        notify  => Service['httpd']
      }
    }
    'ubuntu', 'debian': {
      a2mod { 'ssl':
        ensure => present
      }
    }
    default: {
      package { $httpd::params::ssl_package:
        require => Package['httpd']
      }
      file { $httpd::params::sslconfig_to:
        ensure  => file,
        content => template($httpd::params::sslconfig_from),
        notify  => Service['httpd']
      }
    }
  }
}
