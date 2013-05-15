#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
apt-get update --yes > /dev/null

# 2>&- redirects the output of file descriptor "2", which is stderr, to file
# descriptor (not file, hence the "&") "-", which I think is just null - so
# this just ignores errors

hash curl 		2>&- || apt-get install curl --yes
hash vim 		2>&- || apt-get install vim --yes
hash zsh 		2>&- || apt-get install zsh --yes
hash g++ 		2>&- || apt-get install g++ --yes
hash make 		2>&- || apt-get install make --yes
hash tmux 		2>&- || apt-get install tmux --yes

# Pythonz - Python version manager
hash python 	2>&- || {
	curl -kL https://raw.github.com/saghul/pythonz/master/pythonz-install | bash
	echo "[[ -s $HOME/.pythonz/etc/bashrc ]] && source $HOME/.pythonz/etc/bashrc" >> ~/.bashrc
	. ~/.bashrc
	pythonz install --verbose 2.7.4 3.3.1
}

# Git - latest version + git flow
hash git 2>&- || {
	echo 'Installing latest git'
	apt-get --yes install python-software-properties
	add-apt-repository --yes ppa:git-core/ppa
	apt-get --yes install git bash-completion
	apt-get --yes update
	apt-get --yes upgrade
	apt-get --yes install git-flow
}

# Ruby Version Manager
hash rvm 2>&- || {
	echo 'Installing RVM'
	curl -#L https://get.rvm.io | bash -s stable --autolibs=3 --ruby
	. /usr/local/rvm/scripts/rvm
	rvm install 1.9.3
	rvm --default use 1.9.3
}

# n - a simple node version manager
hash node 2>&- || {
	'Installing node + npm + n'
	add-apt-repository ppa:chris-lea/node.js
	apt-get --yes update
	apt-get --yes install nodejs
	npm install --global n
	n stable
}

# Write custom dotfiles over the $HOME dotfiles
cp /vagrant/vagrant-config/dotfiles/. ~/ --recursive --verbose

# Install fish
cp /vagrant/vagrant-config/fish_2.0.0-201305151006_amd64.deb ~/tmp
sudo dpkg -i ~/tmp/fish_2.0.0-201305151006_amd64.deb

cd /vagrant
bundle 1>/dev/null
echo 'Regenerating binstubs (allows you to omit "bundle exec" from commands)'
gem regenerate_binstubs

echo "Finished up Vagrant VM setup; just have a check that everything works."
echo '-- Python:'
python --version
echo '-- Ruby:'
ruby --version
echo '-- Node:'
node --version
echo '-- Git:'
git --version

alias ruboot='gogogo /vagrant/vagrant-config/boot.rb'

echo 'Run `ruboot` to run the Ruby init.'
echo 'Remember to `git glow init` before you make anything.'
echo 'Righto, back to you.'