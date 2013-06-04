vagrant-slate
=============

Fairly neutral Vagrant setup

Lots nicked from 

https://github.com/mathiasbynens/dotfiles

and 

http://www.without-brains.net/blog/2012/08/12/add-your-own-customization-to-vagrant-boxes/

and 

https://github.com/clindsey/vagrant_rails/blob/master/vagrant_setup.sh

Once the provisioning has finished - you've got the lastest versions of everything etc. - run 

```
vagrant package slate --vagrantfile Vagrantfile.pkg
```
to generate a reusable Vagrant box in your `~/.vagrant.d` directory. This box is static, and doesn't have a provisioner, so if this Vagrant setup works fine, the box you make from it should *always* work as it does today. Obviously, external links can and will break over time but this should be fairly dependable.