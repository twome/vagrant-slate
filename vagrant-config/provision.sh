#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
date >> /vagrant/tmp/provisioning.log
apt-get update --yes > /dev/null

# 2>&- redirects the output of file descriptor "2", which is stderr, to file
# descriptor (not file, hence the "&") "-", which I think is just null - so
# this just ignores errors

hash build-essential 2>&- || apt-get install build-essential --yes
hash curl 2>&- || apt-get install curl --yes
hash vim 2>&- || apt-get install vim --yes
hash zsh 2>&- || apt-get install zsh --yes
hash g++ 2>&- || apt-get install g++ --yes
hash make 2>&- || apt-get install make --yes
hash tmux 2>&- || apt-get install tmux --yes
hash xclip 2>&- || apt-get install xclip --yes
hash jpegoptim 2>&- || apt-get install jpegoptim --yes
hash optipng 2>&- || apt-get install optipng --yes

# Pythonz - Python version manager
hash pythonz 2>&- || {
	curl -kL https://raw.github.com/saghul/pythonz/master/pythonz-install | bash
	echo "[[ -s /home/vagrant/.pythonz/etc/bashrc ]] && . /home/vagrant/.pythonz/etc/bashrc" >> /home/vagrant/.bashrc
	. /home/vagrant/.bashrc
	apt-get --yes install python-pip
	pip install virtualenv virtualenvwrapper
	pythonz install --verbose 2.7.4 3.3.1
}

# Git - latest version + git flow + hub + ftp
hash git 2>&- || {
	echo 'Installing latest git'
	apt-get --yes install python-software-properties
	add-apt-repository --yes ppa:git-core/ppa
	apt-get --yes install git bash-completion
	apt-get --yes update
	apt-get --yes upgrade
	apt-get --yes install git-flow
	curl http://defunkt.io/hub/standalone -sLo ~/bin/hub && chmod +x ~/bin/hub
	git clone https://github.com/git-ftp/git-ftp.git /home/vagrant/utils/git-ftp
	cd /home/vagrant/utils/git-ftp
	git checkout master
	sudo make install
	cd ~
}

# Ruby Version Manager
hash rvm 2>&- || {
	echo 'Installing RVM'
	curl -#L https://get.rvm.io | bash -s stable --autolibs=3 --ruby
	. /usr/local/rvm/scripts/rvm
	rvm install 1.9.3
	rvm --default use 1.9.3
	gem install chef
}

# n - a simple node version manager
hash node 2>&- || {
	'Installing node + npm + n'
	add-apt-repository ppa:chris-lea/node.js
	apt-get --yes update
	apt-get --yes install nodejs
	npm install --global n
	n stable
	npm update --global npm
}
echo "Wait, whats my home dir?"
echo ~
# Write custom dotfiles over the /home/vagrant dotfiles
cp /vagrant/vagrant-config/dotfiles/. /home/vagrant/ --recursive --verbose
# Re-source bash config so all the new variables, aliases etc are available in
# this script as it runs
. /home/vagrant/.bashrc

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

echo '=-=-=-=-=-=-=-=-=-=-=-='
echo 'Provisioning completed!'
echo '=-=-=-=-=-=-=-=-=-=-=-='
# echo "alias rubyinit='ruby /vagrant/vagrant-config/boot.rb'" >> /home/vagrant/.bash_aliases
# echo 'Run `rubyinit` to start the server and site generator'
date >> /vagrant/tmp/provisioning.log
date
echo 'Righto, back to you.'
