# my-vagrant
Vagrant starter with PHP

## Installation

1. Install
   * [VirtualBox](http://virtualbox.org)
   * [VirtualBox extensions](https://www.virtualbox.org/wiki/Downloads)
   * [Vagrant](http://vagrantup.com/)

2. Install Vagrant Plugins

   * [Vagrant Cachier](https://github.com/fgrehm/vagrant-cachier)

     ```
     vagrant plugin install vagrant-cachier
     ```

   * [Vagrant Hosts Updater](https://github.com/cogitatio/vagrant-hostsupdater)

     ```
     vagrant plugin install vagrant-hostsupdater
     ```

3. Clone this and update submodules

   To update submodules, do this:

   ```
   git submodule init
   git submodule update
   ```

## Machines to be used

<dl>
<dt>precise64</dt>
<dd>http://files.vagrantup.com/precise64.box</dd>
<dt>precise32</dt>
<dd>http://files.vagrantup.com/precise32.box</dd>
<dt>Official Ubuntu 14.10 daily Cloud Image amd64 (Development release, No Guest Additions)</dt>
<dd>https://cloud-images.ubuntu.com/vagrant/utopic/current/utopic-server-cloudimg-amd64-vagrant-disk1.box</dd>
<dt>Official Ubuntu 14.10 daily Cloud Image i386 (Development release, No Guest Additions)</dt>
<dd>https://cloud-images.ubuntu.com/vagrant/utopic/current/utopic-server-cloudimg-i386-vagrant-disk1.box</dd>
</dl>

### More machines

* [Vagrantbox.es](http://www.vagrantbox.es/)

## FAQs

### Problems with nfs

* Install nfs-common and nfs-kernel-server

You can disable on config setting `nfs: true`

```
sudo apt-get install nfs-kernel-server
```
