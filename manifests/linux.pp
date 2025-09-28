# Linux package installer class
#
# @param source URL for the Linux package
# @param package Filename of the Linux package
class plexmediaserver::linux (String $source, String $package) {
  $service_provider  = 'systemd'
  $package_target    = "/tmp/${package}"

  case $facts['os']['name'] {
    'Ubuntu': {
      $plex_ubuntu_deps = ['libavahi-core7', 'libdaemon0', 'avahi-daemon']
      $plex_config      = '/etc/default/plexmediaserver'
    }
    'Fedora': {
      $plex_config   = '/etc/sysconfig/PlexMediaServer'
    }
    'CentOS': {
      $plex_config   = '/etc/sysconfig/PlexMediaServer'
    }
    default: { fail("${facts['os']['name']} is not supported by this module.") }
  }

  staging::file { $package:
    source => $source,
    target => $package_target,
    before => Package['plexmediaserver'],
  }

  Package {
    ensure => installed,
  }
  if $facts['os']['name'] == 'Ubuntu' {
    package { 'libavahi-common-data': }
    -> package { 'libavahi-common3': }
    -> package { 'avahi-utils': }
    -> package { $plex_ubuntu_deps:
      before => Package['plexmediaserver'],
    }
  }
}
