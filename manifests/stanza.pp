# == Define: beaver::stanza
#
# This define is responsible for adding stanzas to the beaver config
#
#
# === Parameters
# [*type*]
#   String.  Type to be passed on to logstash
#
# [*source*]
#   String.  Source logfile to be read
#
# [*tags*]
#   String/Array of strings.  What tags should be added to this stream and
#   passed back to logstash
#
# [*add_field*]
#   String/Array of arrays of strings. Custom fields that should be added.
#   Example: [ ['app','app-name'], ['env', 'stage'] ]
#
# [*exclude*]
#   String. Regex to match files that should be left out. eg: .gz$
#
# [*redis_url*]
#   String.  Redis connection url to use for this specific log stream
#
# [*redis_namespace*]
#   String.  Redis namespace to use for this specific log stream
#
# [*format*]
#   String.  What format is the source logfile in.
#   Valid options: json, msgpack, raw, rawjson, string
#   Default (unset): json
#
# [*sincedb_write_interval*]
#   Integer.  Number of seconds between sincedb write updates
#   Default: 300
#
# [*exlcude*]
#   String/Array of strings.  Valid python regex strings to exlude
#   from file globs.
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
define beaver::stanza (
  $type,
  $source                 = undef,
  $tags                   = undef,
  $add_field              = [],
  $redis_url              = undef,
  $redis_namespace        = undef,
  $sincedb_write_interval = undef,
  $exclude                = '',
  $format                 = '',
){

  if $source {
    $source_real = $source
  } else {
    $source_real = $name
  }

  validate_string($type, $source_real)

  include ::beaver
  Class['beaver::package'] ->
  Beaver::Stanza[$name] ~>
  Class['beaver::service']

  $filename = regsubst($name, '[/:\n]', '_', 'GM')
  file { "/etc/beaver/conf.d/${filename}":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    content => template("${module_name}/beaver.stanza.erb"),
    notify  => Class['beaver::service'],
  }

}
