class plexmediaserver::params {
  # Get download URL
  case $facts['os']['name'] {
    'Darwin': {
      $plex_provider  = 'pkgdmg'
      $plex_url       = 'https://downloads.plex.tv/plex-media-server/0.9.12.19.1537-f38ac80'
      $plex_pkg       = 'PlexMediaServer-0.9.12.19.1537-f38ac80-OSX.zip'
    }
    'Ubuntu': {
      $plex_provider  = 'dpkg'
      $plex_url       = 'https://downloads.plex.tv/plex-media-server/0.9.12.19.1537-f38ac80'
      $plex_pkg       = "plexmediaserver_0.9.12.19.1537-f38ac80_${facts['os']['architecture']}.deb"
    }
    'Fedora': {
      $plex_provider  = 'rpm'
      $plex_url       = 'https://downloads.plex.tv/plex-media-server/0.9.12.19.1537-f38ac80'
      $plex_pkg       = "plexmediaserver-0.9.12.19.1537-f38ac80.${facts['os']['architecture']}.rpm"
    }
    'CentOS': {
      $plex_provider  = 'rpm'
      $plex_url       = 'https://downloads.plex.tv/plex-media-server/0.9.12.19.1537-f38ac80'
      $plex_pkg       = "plexmediaserver-0.9.12.19.1537-f38ac80.${facts['os']['architecture']}.rpm"
    }
    default: { fail("${facts['os']['name']} is not supported by this module.") }
  }

  # General stuff
  $plex_user                                        = 'plex'
  $plex_media_server_home                           = '/usr/lib/plexmediaserver'
  $plex_media_server_application_support_dir_array  = [
    '`getent passwd $PLEX_USER|awk -F : \'{print $6}\'`',
    '/Library/Application Support',
  ]
  $plex_media_server_application_support_dir        =
    join($plex_media_server_application_support_dir_array, '')
  $plex_media_server_max_plugin_procs               = '6'
  $plex_media_server_max_stack_size                 = '10000'
  $plex_media_server_max_lock_mem                   = '3000'
  $plex_media_server_max_open_files                 = '4096'
  $plex_media_server_tmpdir                         = '/tmp'
  $plex_install_latest                              = false
}
