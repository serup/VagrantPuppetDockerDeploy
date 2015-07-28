# VagrantPuppetDockerDeploy
via vagrant a master and one node is created in VirtualBox and via puppet master and puppet agent on master and node, then the puppetlabs module Docker is installed on node01

***********************************************************************
** get started with VagrantPuppetDockerDeploy project on new machine **
***********************************************************************
1. Clone the gerrit repository
git clone ssh://serup@review.gerrithub.io:29418/serup/VagrantPuppetDockerDeploy && scp -p -P 29418 serup@review.gerrithub.io:hooks/commit-msg VagrantPuppetDockerDeploy/.git/hooks/
cd VagrantPuppetDockerDeploy/
2. Create your own branch and checkout
git branch <your branch name>
git checkout <your branch name>
3. Start creating / modifying files
4. Checkin to your own branch using this setup
 first time you checkin your branch needs to be created on gerrithub, thus make following command
   git add <your files..>
   git commit -m "<your checkin info>"
   git push -u origin <your branch name>
 next time use normal push
git push origin HEAD:refs/for/<your branch name>
5. Check if virtualbox is installed, and if not then install
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' 2>&1 virtualbox |grep "install ok installed")
if [ "" == "$PKG_OK" ]; then
  echo "Virtualbox was not found, now it will be installed - please wait..."
  sudo apt-get --force-yes --yes install virtualbox 
fi
6. Check if vagrant is installed, and if not then install
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' 2>&1 vagrant |grep "install ok installed")
if [ "" == "$PKG_OK" ]; then
  echo "vagrant was not found, now it will be installed - please wait..."
  sudo apt-get --force-yes --yes install virtualbox 
fi
7. Check if puppetlabs-release is installed, and if not then install
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' 2>&1 puppetlabs-release |grep "install ok installed")
if [ "" == "$PKG_OK" ]; then
  echo "puppetlabs-release was not found, now it will be installed - please wait..."
  wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
  sudo dpkg -i puppetlabs-release-trusty.deb
  sudo apt-get update 
fi
8. Fetch newest puppet docker module, for later install in node01 - make sure you are standing in you new cloned directory! example :  ~/GerritHub/VagrantPuppetDockerDeploy$
puppet module install garethr/docker --modulepath ./puppet/trunk/environments/devtest/modules
9. Start vagrant
vagrant up
10. Start node01
vagrant up node01.docker.local
11. log into node01
vagrant ssh node01.docker.local
12. Check if docker is working - the puppet agent should have run; puppet agent -t
docker
13. if needed then run puppet agent
sudo -s
puppet agent -t
 
*****************************
