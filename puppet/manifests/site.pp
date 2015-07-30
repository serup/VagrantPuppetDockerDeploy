node default {
  # Test message
  notify { "Debug output on ${hostname} node.": }
}

node /^node01.*/ {

  # howto manually apply this manifest file -- make sure you are sudo
  # puppet apply /vagrant/puppet/manifests/site.pp --modulepath /vagrant/puppet/trunk/environments/devtest/modules/

  # Test message
  notify { "Debug output on ${fqdn}": }

  # NB! Needed BEFORE docker class, otherwise it will fail during install
  exec { "apt-update":
    command => "/usr/bin/apt-get update"
  }
  Exec["apt-update"] -> Package <| |>

  include sudo
  include 'docker'

  # Add adm group to sudoers with NOPASSWD
  sudo::conf { 'vagrant':
    priority => 01,
    content  => "vagrant ALL=(ALL) NOPASSWD: ALL",
  }

  docker::image { 'ubuntu':
   image_tag => 'trusty',
  }

  docker::run { 'helloworld':
    image   => 'ubuntu',
    command => '/bin/sh -c "while true; do echo hello world; sleep 1; done"',
  }

  docker::run { 'goodbyecruelworld':
    image 	=> 'ubuntu',
    command 	=> '/bin/sh -c "while true; do echo goodbye cruel world; sleep 1; done"',
  }

#  docker::image { 'whalesay': }

}
