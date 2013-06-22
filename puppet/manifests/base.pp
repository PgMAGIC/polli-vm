Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

# setup apt module
class { 'apt':
  always_apt_update    => false,
  disable_keys         => undef,
  proxy_host           => false,
  proxy_port           => '8080',
  purge_sources_list   => false,
  purge_sources_list_d => false,
  purge_preferences_d  => false
}

exec { "apt-get-update":
  command => "apt-get update",
  provider => shell,
}

package { 'git':
        ensure => installed,
}

vcsrepo { "/usr/src/polli":
  provider => git,
  source => 'https://github.com/vkoop/polli.git',
  revision => 'master',
  ensure => latest,
  require => Package['git'],
}


$qrdeps = [ "build-essential", "pkg-config", "libcairo2-dev", "imagemagick", "nodejs"]

apt::ppa { "ppa:chris-lea/node.js": }
->
package { $qrdeps: ensure => "installed",
  require => Exec['apt-get-update']
}
->
exec { "install npm deps": 
  command => "cd /usr/src/polli; npm install;",
  provider => shell,
  require => Vcsrepo['/usr/src/polli'],
}

file{"/etc/init/polli.conf":
  ensure => "present",
  owner => "root",
  group => "root",
  mode  => 770,
  source => "/tmp/vagrant-puppet/templates/polli.upstart.conf",
}



exec { "install coffeescript":
  command => "npm -g install coffee-script;",
  provider => shell,
  require => Exec['install npm deps']
}
->
service { 'polli':
  ensure => running,
  enable => true,
  subscribe => [
    File["/etc/init/polli.conf"],
  ]
}
