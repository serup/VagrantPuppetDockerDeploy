echo "Updating source.list file"
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
echo "deb http://archive.canonical.com/ubuntu trusty partner" | sudo tee -a /etc/apt/sources.list
echo "deb-src http://archive.canonical.com/ubuntu trusty partner" | sudo tee -a /etc/apt/sources.list
sudo sed -i -e 's/archive.ubuntu.com\|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list
