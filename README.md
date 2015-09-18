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
  . ./install.sh <docker image project name fx. skeleton>
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
**Download a docker test image**
```javascript 
 docker run docker/whalesay cowsay boo
```
**List installed docker images**
```
docker images
```
**Attach to a docker image - log into it**
```
docker attach  $(docker ps|grep docker-image-skeleton|awk '{print $1}')
```

 
*****************************
