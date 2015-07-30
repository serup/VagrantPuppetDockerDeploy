# VagrantPuppetDockerDeploy
via vagrant a master and one node is created in VirtualBox and via puppet master and puppet agent on master and node, then the puppetlabs module Docker is installed on node01

*********************************************************************
**get started with VagrantPuppetDockerDeploy project on new machine**
*********************************************************************
*1 - Clone the gerrit repository
```javascript 
  git clone ssh://serup@review.gerrithub.io:29418/serup/VagrantPuppetDockerDeploy && scp -p -P 29418 serup@review.gerrithub.io:hooks/commit-msg VagrantPuppetDockerDeploy/.git/hooks/
  cd VagrantPuppetDockerDeploy/
```
*2 - Create your own branch and checkout
```javascript 
  git branch <your branch name>
  git checkout <your branch name>
```
*3 - Setup environment and start creating / modifying files
```
  run the install script - it will setup environment variables, and install needed modules for the project, used later in vagrant up
  . ./install.sh
  use your favorite editor to write code
```
*4 - Checkin to your own branch using this setup
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
*5 - Check if virtualbox is installed, and if not then install
```javascript 
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' 2>&1 virtualbox |grep "install ok installed")
if [ "" == "$PKG_OK" ]; then
  echo "Virtualbox was not found, now it will be installed - please wait..."
  sudo apt-get --force-yes --yes install virtualbox 
fi
```
*6 - Check if vagrant is installed, and if not then install
```javascript 
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' 2>&1 vagrant |grep "install ok installed")
if [ "" == "$PKG_OK" ]; then
  echo "vagrant was not found, now it will be installed - please wait..."
  sudo apt-get --force-yes --yes install virtualbox 
fi
```
*7 - Check if puppetlabs-release is installed, and if not then install
```javascript 
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' 2>&1 puppetlabs-release |grep "install ok installed")
if [ "" == "$PKG_OK" ]; then
  echo "puppetlabs-release was not found, now it will be installed - please wait..."
  wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
  sudo dpkg -i puppetlabs-release-trusty.deb
  sudo apt-get update 
fi
```
*8 - Fetch newest puppet docker module, for later install in node01 - make sure you are standing in you new cloned directory! example :  ~/GerritHub/VagrantPuppetDockerDeploy$
```javascript 
  puppet module install garethr/docker --modulepath ./puppet/trunk/environments/devtest/modules
```
*********************************************************************
**Following can be done after install**
*********************************************************************
*9 - Start vagrant
```javascript 
  vagrant up
```
*10 - Start node01
```javascript 
  vagrant up node01.docker.local
```
*11 - log into node01
```javascript 
  vagrant ssh node01.docker.local
```
*12 - Check if docker is working - the puppet agent should have run; puppet agent -t
```javascript 
  docker
```
*13 - if needed then run puppet agent
```javascript 
  sudo -s
  puppet agent -t
```
 
*****************************
