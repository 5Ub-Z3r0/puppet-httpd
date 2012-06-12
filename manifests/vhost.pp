# Definition: httpd::vhost
#
# This class installs Apache Virtual Hosts
#
# Parameters:
# - $content: the content of the configuration file, or
# - $source:  the source of the configuration file
# - $priority: the priority of the file (default: 00)
#
# Actions:
# - Installs Apache Virtual Hosts
#
# Requires:
# - The HTTPD class
#
#  httpd::vhost { 'site.name.fqdn':
#    priority => '20',
#    content => '
#      <virtualhost *:80>
#      ....
#      </virtualhost>
#    ',
#  }
#

define httpd::vhost(
  $content = undef,
  $priority = '00',
  $source = undef
){

  include httpd

  file { "${httpd::params::vdir}/${priority}-${name}.conf":
    ensure  => file,
    content => $content,
    source  => $source,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['httpd'],
    notify  => Service['httpd']
  }
}
