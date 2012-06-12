# Class: apache::php
#
# This class installs PHP for Apache
#
# Parameters:
# - $php_package is the name of the php packages
# - $phpconfig_from is the source of the php.ini file
# - $phpconfig_to is the destination of the php.ini file
#
# Actions:
#   - Install Apache PHP package
#
# Requires:
#
# Sample Usage:
#
class httpd::php {

  include httpd::params

  package { $httpd::params::php_package:
    ensure => present
  }

  file { $httpd::params::phpconfig_to:
    ensure  => file,
    content => template($httpd::params::phpconfig_from),
    require => Package [ $httpd::params::php_package ],
    notify  => Service['httpd']
  }
}
