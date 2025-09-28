# Plex media server package installation and configuration class
#
# @param plex_provider                              Default: (Automatically selected based on OS family)
# @param plex_url                                   Default: (Automatically selected based on OS family)
# @param plex_pkg                                   Default: (Automatically selected based on OS family)
# @param plex_install_latest                        Default: false
# @param plex_user                                  Default: plex
# @param plex_media_server_home                     Default: /usr/lib/plexmediaserver
# @param plex_media_server_application_support_dir  Default: `getent passwd $plex_user|awk -F : '{print $6}'`/Library/Application Support
# @param plex_media_server_max_plugin_procs         Default: 6
# @param plex_media_server_max_stack_size           Default: 10000
# @param plex_media_server_max_lock_mem             Default: 3000
# @param plex_media_server_max_open_files           Default: 4096
# @param plex_media_server_tmpdir                   Default: /tmp
class plexmediaserver (
  String $plex_provider                      =
    $plexmediaserver::params::plex_provider,
  String $plex_url                           =
    $plexmediaserver::params::plex_url,
  String $plex_pkg                           =
    $plexmediaserver::params::plex_pkg,
  String $plex_user                          =
    $plexmediaserver::params::plex_user,
  Boolean $plex_install_latest               =
    $plexmediaserver::params::plex_install_latest,
  String $plex_media_server_home             =
    $plexmediaserver::params::plex_media_server_home,
  String $plex_media_server_application_support_dir =
    $plexmediaserver::params::plex_media_server_application_support_dir,
  String $plex_media_server_max_plugin_procs =
    $plexmediaserver::params::plex_media_server_max_plugin_procs,
  String $plex_media_server_max_stack_size   =
    $plexmediaserver::params::plex_media_server_max_stack_size,
  String $plex_media_server_max_lock_mem     =
    $plexmediaserver::params::plex_media_server_max_lock_mem,
  String $plex_media_server_max_open_files   =
    $plexmediaserver::params::plex_media_server_max_open_files,
  String $plex_media_server_tmpdir           =
    $plexmediaserver::params::plex_media_server_tmpdir
) inherits plexmediaserver::params {
  $plex_installer = $facts['os']['name'] ? {
    'Darwin' => 'plexmediaserver::darwin',
    default  => 'plexmediaserver::linux',
  }

  if ($plex_install_latest) {
    # Fetch latest version from plex website
    $plex_latest = latest_version($facts['os']['family'])
    notice("Automatically selecting latest plex package: ${plex_latest['pkg']}")
    class { $plex_installer:
      package => $plex_latest['pkg'],
      source  => "${plex_latest['url']}/${plex_latest['pkg']}",
    }
  } else {
    class { $plex_installer:
      package => $plex_pkg,
      source  => "${plex_url}/${plex_pkg}",
    }
  }

  package { 'plexmediaserver':
    ensure   => installed,
    provider => $plex_provider,
    source   => getvar("${plex_installer}::pkg_target"),
    require  => Class[$plex_installer],
  }

  $plex_config = getvar("${plex_installer}::plex_config")

  if $plex_config {
    file { 'plexconfig':
      ensure  => file,
      path    => $plex_config,
      owner   => 'root',
      group   => 'root',
      mode    => '0775',
      content => template("${module_name}/PlexMediaServer.erb"),
      require => Package['plexmediaserver'],
      notify  => Service['plexmediaserver'],
    }
  }

  service { 'plexmediaserver':
    ensure   => running,
    enable   => true,
    provider => getvar("${plex_installer}::service_provider"),
  }
}
