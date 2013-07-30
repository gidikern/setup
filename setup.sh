#!/bin/bash
# Simple setup.sh for configuring Ubuntu 12.04 LTS EC2 instance
# for headless setup.

BIT32='32'
while getopts b: option
do
        case "${option}"
        in
                b) BIT32=${OPTARG};;
        esac
done

# Install nvm: node-version manager
# https://github.com/creationix/nvm
sudo apt-get install -y git
sudo apt-get install -y curl
curl https://raw.github.com/creationix/nvm/master/install.sh | sh

# Load nvm and install latest production node
source $HOME/.nvm/nvm.sh
nvm install v0.10.12
nvm use v0.10.12

# Install jshint to allow checking of JS code within emacs
# http://jshint.com/
npm install -g jshint

# Install rlwrap to provide libreadline features with node
# See: http://nodejs.org/api/repl.html#repl_repl
sudo apt-get install -y rlwrap

# Install emacs24
# https://launchpad.net/~cassou/+archive/emacs
sudo apt-add-repository -y ppa:cassou/emacs
sudo apt-get -qq update
sudo apt-get install -y emacs24-nox emacs24-el emacs24-common-non-dfsg

# Install sublime-text-2
sudo add-apt-repository ppa:webupd8team/sublime-text-2 
sudo apt-get update
sudo apt-get install sublime-text

# Install Python 2.7
sudo add-apt-repository ppa:fkrull/deadsnakes
sudo apt-get update
sudo apt-get install python2.7

# Install Heroku toolbelt
# https://toolbelt.heroku.com/debian
wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh

# Installing chrome
if [ $BIT32 = '32' ]; then
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb
else
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
fi

sudo dpkg -i google-chrome*
if [ "$?" -ne "0" ]; then
  echo "Chrome dpkg failed trying app-get"	
  sudo apt-get install -f
  echo "chrome installed"
 else  
 	echo "chrome installed"
fi

# create myrepo directory
cd $HOME
if [ -d ./myrepo/ ]; then
  echo 'myrepo directory exists'
else 
  mkdir myrepo		
fi

# git pull and install dotfiles as well
cd $HOME

if [ -d ./myrepo/dotfiles/ ]; then
mv myrepo/dotfiles myrepo/dotfiles.old
fi

if [ -d ./myrepo/.emacs.d/ ]; then
mv ./myrepo/.emacs.d ./myrepo/.emacs.d~
fi

cd $HOME/myrepo/
git clone https://github.com/gidikern/dotfiles.git

cd $HOME
ln -sb myrepo/dotfiles/.screenrc .
ln -sb myrepo/dotfiles/.bash_profile .
ln -sb myrepo/dotfiles/.bashrc .
ln -sb myrepo/dotfiles/.bashrc_custom .
ln -sf myrepo/dotfiles/.emacs.d .

# Set sublime packages from dotfiles
cp -u $HOME/myrepo/dotfiles/.sublime-text-2 $HOME/.config/sublime-text-2/

echo "Please enter the github user name [ENTER]:"
read github_username

echo "Please enter the github user email [ENTER]:"
read github_useremail

git config --global user.name $github_username
git config --global user.email $github_useremail
git clone https://github.com/gidikern/bitstarter.git
cd $HOME/myrepo/bitstarter


