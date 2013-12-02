# == Class: kamailio
#
# Full description of class kamailio here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { kamailio:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2011 Your name here, unless otherwise noted.
#
class kamailio(
  $kamailio_autostart = true,
  $kamailio_version = "4.0"
) {

  case $kamailio_version {
    '4.0': { $kamailio_pkg_version = "40" }
    default: { notify "Version not found" }
  }

  include apt

  apt::key { 'kamailio':
    key   => '07D5C01D',
    key_source => 'http://deb.kamailio.org/kamailiodebkey.gpg'
  }

  apt::source { 'kamailio':
    location => "http://deb.kamailio.org/kamailio${kamailio_pkg_version}/",
    release => "wheezy",
    repos => "main",
    include_src => true
  }

  $kamailio_packages = [ "kamailio" ]

  package { "kamailio":
    name => $kamailio_packages,
    ensure => 'installed',
    require => Apt::Source['kamailio'],
  }

  file { "/etc/default/kamailio":
    path => "/etc/default/kamailio",
    content => template("kamailio/default/kamailio"),
    require => Package['kamailio']
  }
}
