#!/usr/bin/env bash -l
echo "*******************************************************"
echo "** Installing vagrant, puppetlabs, virtualbox        **"
echo "*******************************************************"
DIR=$(cd . && pwd)
export DOCKER_PUPPET_PATH="$DIR""/puppet/trunk/environments/"
echo "setting DOCKER_PUPPET_PATH=$DOCKER_PUPPET_PATH"
echo $DOCKER_PUPPET_PATH > env_docker_puppet_path
mkdir -p $DOCKER_PUPPET_PATH
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' 2>&1 virtualbox |grep "install ok installed")
if [ "" == "$PKG_OK" ]; then
  echo -n "- install Virtualbox "
  sudo apt-get --force-yes --yes install virtualbox 
  echo " - done."
else
  echo "- Vitualbox installed"
fi
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' 2>&1 vagrant |grep "install ok installed")
if [ "" == "$PKG_OK" ]; then
  echo -n "- install vagrant "
  sudo apt-get --force-yes --yes install virtualbox 
  echo " - done."
else
  echo "- vagrant installed"
fi
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' 2>&1 puppetlabs-release |grep "install ok installed")
if [ "" == "$PKG_OK" ]; then
#  echo "puppetlabs-release was not found, now it will be installed - please wait..."
  echo -n "- install puppetlabs-release "
  wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
  sudo dpkg -i puppetlabs-release-trusty.deb
  sudo apt-get update 
  echo " - done."
else
  echo "- puppetlabs-release installed"
fi
echo "fetch saz/sudo puppet module"
puppet module install saz/sudo --modulepath ./puppet/trunk/environments/devtest/modules
echo "fetch docker puppet module"
puppet module install garethr/docker --modulepath ./puppet/trunk/environments/devtest/modules
echo "*******************************************************************************************"
echo "environment is now ready! you may run vagrant up and then vagrant up node01.docker.local"
echo "*******************************************************************************************"
