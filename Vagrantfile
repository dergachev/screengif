# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "precise64"

  # config.vm.provision :shell, :inline => "apt-get install -y vim curl git"

  config.vm.provision :shell, :inline => <<-EOH
    apt-get update
    apt-get install -y ffmpeg gifsicle imagemagick libmagickwand-dev
    apt-get -y install ruby1.9.1 ruby1.9.1-dev 
    gem install bundler --no-rdoc --no-ri
    cd /vagrant
    bundle install
  EOH

  # test that everything is installed correctly by generating ./output/demo.gif
  config.vm.provision :shell, :inline => <<-EOH
    cd /vagrant
    test -f ./output/demo.gif && exit 0 # ensures this script runs just once
    echo "Testing deployment by converting ./demo.mov to ./output/demo.gif"
    mkdir -p ./output
    # vagrant colors stderr red (undesirable), so redirect it to stdout
    ./screengif.rb --input demo.mov --output ./output/demo.gif 2>&1
  EOH
end
