# Darwin package installer class

# @param source URL for the Darwin package
# @param package Filename of the Darwin package
class plexmediaserver::darwin (String $source, String $package) {
  $service_provider = 'launchd'
  $package_target   = "/tmp/${package}"

  staging::deploy { $package:
    source => $source,
    target => $package_target,
    before => Package['plexmediaserver'],
  }
}
