Vagrant.configure('2') do |config|
  config.vagrant.plugins = ['vagrant-reload']
  config.vm.box = 'rgl/windows-server-2019-standard-amd64'
  config.vm.provider 'virtualbox' do |v|
    v.gui = true
    v.linked_clone = true
    v.check_guest_additions = false
    v.customize ['modifyvm', :id, '--nested-hw-virt', 'on']
  end
  config.vm.network 'public_network',
                    use_dhcp_assigned_default_route: true,
                    bridge: ['eno1']
  config.vm.provision 'docker-group',
                      type: 'shell',
                      path: 'https://raw.githubusercontent.com/StefanScherer/packer-windows/main/scripts/docker/add-docker-group.ps1'
  config.vm.provision 'install-docker',
                      type: 'shell',
                      path: 'https://github.com/StefanScherer/packer-windows/raw/main/scripts/docker/install-docker.ps1',
                      env: { docker_version: '20.10.0' }
  config.vm.provision 'docker-pull',
                      type: 'shell',
                      path: 'https://github.com/StefanScherer/packer-windows/raw/main/scripts/docker/docker-pull.ps1',
                      env: { docker_images: 'mcr.microsoft.com/windows/nanoserver:1809 mcr.microsoft.com/windows/servercore:ltsc2019 mcr.microsoft.com/windows/servercore:1809 mcr.microsoft.com/windows:1809' }

  config.vm.provision 'open-docker-insecure-port.ps1',
                      type: 'shell',
                      path: 'https://github.com/StefanScherer/packer-windows/raw/main/scripts/docker/open-docker-insecure-port.ps1'

  config.vm.provision :reload
end
