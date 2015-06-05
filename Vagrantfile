# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box              = 'chef/centos-7.0'
  config.vm.box_check_update = true

  config.vm.network 'private_network', ip: '192.168.100.100'

  config.vm.provider 'virtualbox' do |vb|
    vb.gui    = false
    vb.memory = '1024'
  end

  provisions = %Q{
    function install_required_binaries {
      yum -y install epel-release
      yum -y install git ruby rubygems puppet
      gem install r10k --no-rdoc --no-ri --bindir /usr/bin
    }

    function cp_chown_chmod {
      local NAME=$1
      local DEST=$2
      local CP='sudo cp -rv'

      $CP /vagrant/$NAME $DEST
      sudo chown -Rv root:root $DEST/$NAME
      sudo chmod -Rv 664 $DEST/$NAME
    }

    function prepare_puppet_files {
      cp_chown_chmod puppet /etc
      cp_chown_chmod hiera /var/lib
    }

    function fetch_puppet_modules {
      cd /etc/puppet
      sudo r10k puppetfile install
    }

    function run_puppet {
      sudo puppet apply --modulepath=/etc/puppet/modules \
        /etc/puppet/manifests/site.pp
    }

    function main {
      install_required_binaries
      prepare_puppet_files
      fetch_puppet_modules
      run_puppet
    }

    main
  }

  config.vm.provision 'shell', inline: provisions
end
