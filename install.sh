#!/usr/bin/env bash -l
echo "********************************************************"
echo "** Installing vagrant, puppetlabs, virtualbox, docker **"
echo "********************************************************"
DIR=$(cd . && pwd)
export DOCKER_PUPPET_PATH="$DIR""/puppet/trunk/environments/"
echo "setting DOCKER_PUPPET_PATH=$DOCKER_PUPPET_PATH"
echo $DOCKER_PUPPET_PATH > env_docker_puppet_path
mkdir -p $DOCKER_PUPPET_PATH
JQ_OK=$(dpkg --get-selections | grep -v deinstall|grep jq)
if [ "" == "$JQ_OK" ]; then
  echo -n "- install jq - for handling json files inside batch"
  sudo apt-get install jq
  echo " - done."
else
  echo "- jq installed"
fi
project="$1"
image=""
if [ "file=setup.config" == "$project" ] || [ "" == "$project" ]; then 
   echo "  ___________________________________________________________________ "
   echo "    Warning no docker PROJECT name - please add it as first parameter - like this '. ./install.sh skeleton'"
else
   image=$(cat setup.conf | jq --raw-output '.'"$project"'.image')
fi
if [ "docker-image-skeleton" == "$image" ]; then
   echo -n "- setup for docker images for skeleton "
   scp=$(cat setup.conf | jq --raw-output '.'"$project"'.scp')
   mkdir -p $DOCKER_PUPPET_PATH/devtest/modules/docker_images/
   scp $scp $DOCKER_PUPPET_PATH/devtest/modules/docker_images/
   if [ "$?" != 0 ]; then
      echo "- docker images not installed"
   else
      echo "- docker images installed"
   fi
else
   echo "- docker images NOT installed - please check setup.conf to see if it is correct"
fi
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' 2>&1 virtualbox |grep "install ok installed")
if [ "" == "$PKG_OK" ]; then
  echo -n "- install Virtualbox "
  sudo apt-get --force-yes --yes install virtualbox 
  echo " - done."
else
  echo "- Virtualbox installed"
fi
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' 2>&1 vagrant |grep "install ok installed")
if [ "" == "$PKG_OK" ]; then
  echo -n "- install vagrant "
  sudo apt-get --force-yes --yes install vagrant 
  echo " - done."
else
  echo "- vagrant installed"
  echo "- destroy old setup, so new can run"
  vagrant destroy
fi
VBOX_OK=$(vagrant box list|awk 'BEGIN {strtmp=$1} END {print $strtmp}')
if [ "" == "$VBOX_OK" ]; then
  echo "vbox not found - installing.."
  vagrant box add ubuntu/trusty64 https://atlas.hashicorp.com/ubuntu/boxes/trusty64/versions/14.04/providers/virtualbox.box
else
  echo "- vbox installed"
fi
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' 2>&1 puppetlabs-release |grep "install ok installed")
if [ "" == "$PKG_OK" ]; then
#  echo "puppetlabs-release was not found, now it will be installed - please wait..."
  echo -n "- install puppetlabs-release "
  sudo apt-get install puppet-common
  wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
  sudo dpkg -i puppetlabs-release-trusty.deb
  sudo apt-get update 
  echo " - done."
else
  echo "- puppetlabs-release installed"
fi
SAZ_OK=$(puppet module list --modulepath ./puppet/trunk/environments/devtest/modules | grep saz-sudo)
if [ "" == "$SAZ_OK" ]; then
  echo -n "- install saz/sudo"
  puppet module install saz/sudo --modulepath ./puppet/trunk/environments/devtest/modules
  echo " - done."
else
  echo "- saz/sudo puppet module installed"
fi
DOCKER_OK=$(puppet module list --modulepath ./puppet/trunk/environments/devtest/modules | grep garethr-docker)
if [ "" == "$DOCKER_OK" ]; then
  echo -n "- install garethr/docker puppet module"
  puppet module install garethr/docker --modulepath ./puppet/trunk/environments/devtest/modules
  echo " - done."
else
  echo "- garethr/docker puppet module installed"
fi
echo "*******************************************************************************************"
echo "environment is now ready! you may run vagrant up and then vagrant up node01.docker.local"
echo "*******************************************************************************************"
vagrant up
vagrant up node01.docker.local
