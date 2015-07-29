node default {
  # Test message
  notify { "Debug output on ${hostname} node.": }
}

node /^node01.*/ {
  # Test message
  notify { "Debug output on ${fqdn}": }

  # NB! Needed BEFORE docker class, otherwise it will fail during install
  exec { "apt-update":
    command => "/usr/bin/apt-get update"
  }
  Exec["apt-update"] -> Package <| |>

  include 'docker'
  include sudo

  # Add adm group to sudoers with NOPASSWD
  sudo::conf { 'vagrant':
    priority => 01,
    content  => "vagrant ALL=(ALL) NOPASSWD: ALL",
  }

  docker::image { 'base':
   ensure => 'absent',
  }

  docker::image { 'ubuntu':
   ensure  => 'absent',
   tag     => 'precise'
  }
}
