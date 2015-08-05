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

  docker::image { 'moderor':
   docker_tar => '/vagrant/puppet/trunk/environments/devtest/modules/docker_images_download/docker-image-moderor.tar' 
  }

  exec { "docker_run":
     command => "/usr/bin/sudo docker run -d -t docker-image-moderor",
     require => docker::image[moderor]
  }

}
