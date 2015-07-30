# VagrantPuppetDockerDeploy
via vagrant a master and one node is created in VirtualBox and via puppet master and puppet agent on master and node, then the puppetlabs module Docker is installed on node01

*********************************************************************
**get started with VagrantPuppetDockerDeploy project on new machine**
*********************************************************************
**Clone the gerrit repository**
```javascript 
  git clone ssh://serup@review.gerrithub.io:29418/serup/VagrantPuppetDockerDeploy && scp -p -P 29418 serup@review.gerrithub.io:hooks/commit-msg VagrantPuppetDockerDeploy/.git/hooks/
  cd VagrantPuppetDockerDeploy/
```
**Create your own branch and checkout**
```javascript 
  git branch <your branch name>
  git checkout <your branch name>
```
**Setup environment and start creating / modifying files**
```
  run the install script - it will setup environment variables, and install needed modules for the project, used later in vagrant up
  . ./install.sh
  use your favorite editor to write code
```
**Checkin to your own branch using this setup**
 first time you checkin your branch needs to be created on gerrithub, thus make following command
```javascript 
   git add <your files..>
   git commit -m "<your checkin info>"
   git push -u origin <your branch name>
```
 next time use normal push - this will create a new review on GerritHub and you must review and approve it before submit - you can find your reviews here:
```
  https://review.gerrithub.io/#/q/project:  < your branch name >  /VagrantPuppetDockerDeploy
```
 Normal push command :
```javascript 
   git push origin HEAD:refs/for/<your branch name>
```
 NB! Inorder to make checkin on this GerritHub project, then you need to create a RSA public key and send to administrator - he will then add it to users, making it possible for you to make reviews on your own branch

*********************************************************************
**Next steps can be found inside the install.sh script**
*********************************************************************
```javascript 
#!/usr/bin/env bash -l
echo "*******************************************************"
echo "** Installing vagrant, puppetlabs, virtualbox        **"
echo "*******************************************************"
DIR=$(cd . && pwd)
export DOCKER_PUPPET_PATH="$DIR""/puppet/trunk/environments/"
echo "setting DOCKER_PUPPET_PATH=$DOCKER_PUPPET_PATH"
echo $DOCKER_PUPPET_PATH > env_docker_puppet_path
mkdir -p $DOCKER_PUPPET_PATH

#Check if virtualbox is installed, and if not then install
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' 2>&1 virtualbox |grep "install ok installed")
if [ "" == "$PKG_OK" ]; then
  echo -n "- install Virtualbox "
  sudo apt-get --force-yes --yes install virtualbox 
  echo " - done."
else
  echo "- Vitualbox installed"
fi

#Check if vagrant is installed, and if not then install
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' 2>&1 vagrant |grep "install ok installed")
if [ "" == "$PKG_OK" ]; then
  echo -n "- install vagrant "
  sudo apt-get --force-yes --yes install virtualbox 
  echo " - done."
else
  echo "- vagrant installed"
fi
vagrant box add ubuntu/trusty64 https://atlas.hashicorp.com/ubuntu/boxes/trusty64/versions/14.04/providers/virtualbox.box

#Check if puppetlabs-release is installed, and if not then install
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' 2>&1 puppetlabs-release |grep "install ok installed")
if [ "" == "$PKG_OK" ]; then
  echo -n "- install puppetlabs-release "
  sudo apt-get install puppet-common
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
```
*********************************************************************
**Following can be done after install**
*********************************************************************
**Start vagrant**
```javascript 
  vagrant up
```
**Start node01**
```javascript 
  vagrant up node01.docker.local
```
**log into node01**
```javascript 
  vagrant ssh node01.docker.local
```
**Check if docker is working - the puppet agent should have run; puppet agent -t**
```javascript 
  docker
```
**if needed then run puppet agent**
```javascript 
  sudo -s
  puppet agent -t
```

*****************************
