# == Class: beaver::params
#
# This class is responsible for setting defaults
#
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
class beaver::params {
  $enable                 = true
  $user                   = 'beaver'
  $group                  = 'beaver'
  $home                   = '/home/beaver'
  $venv                   = "${home}/venv"
  $package_name           = 'beaver'
  $package_provider       = 'pip'
  $python_version         = '2.7'
  $version                = 'installed'
  $redis_url              = 'redis://localhost:6379/0'
  $redis_namespace        = 'logstash:beaver'
  $queue_timeout          = 60
  $enable_sincedb         = true
  $sincedb_path           = '/tmp/beaver_since.db'
  $multiline_regex_after  = ''
  $multiline_regex_before = ''
  $queue_timeout          = 60
  $discover_interval      = 1

   # packages
  case $::operatingsystem {
    'RedHat', 'CentOS', 'Fedora', 'Scientific', 'Amazon', 'OracleLinux', 'SLES', 'OpenSuSE': {
      # main application
      $init_file = 'beaver.init.erb'
    }
    'Debian', 'Ubuntu': {
      # main application
      $init_file = 'beaver.init-debian.erb'
    }
    default: {
      fail("\"${module_name}\" provides no package default value
            for \"${::operatingsystem}\"")
    }
  }
}
