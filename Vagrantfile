# rubocop:disable Metrics/BlockLength
Vagrant.configure('2') do |config|
  config.vagrant.plugins = ['vagrant-reload']
  config.vm.provider 'virtualbox' do |v|
    v.linked_clone = true
    v.check_guest_additions = false
    v.customize ['modifyvm', :id, '--nested-hw-virt', 'on']
  end
  config.vm.define 'kube1' do |kube|
    kube.vm.network 'public_network',
                    use_dhcp_assigned_default_route: true,
                    bridge: ['eno1']
    kube.vm.box = 'bento/ubuntu-20.04'
    kube.vm.provision 'setup-microk8s', type: 'shell', path: 'setup-microk8s.sh'
  end
  config.vm.define 'windows' do |windows|
    # Should be a stripped down Windows server for size.  This works for a demo
    windows.vm.box = 'rgl/windows-server-2019-standard-amd64'
    windows.vm.provider 'virtualbox' do |v|
      v.gui = true
    end
    windows.vm.network 'public_network',
                       use_dhcp_assigned_default_route: true,
                       bridge: ['eno1']
    windows.vm.provision 'hyperv',
                         type: 'shell',
                         # This okay for quick prototyping, a bad idea for production
                         path: 'https://github.com/StefanScherer/packer-windows/raw/main/scripts/docker/2016/install-containers-feature.ps1'
    windows.vm.provision :reload
    windows.vm.provision 'docker-group',
                         type: 'shell',
                         path: 'https://raw.githubusercontent.com/StefanScherer/packer-windows/main/scripts/docker/add-docker-group.ps1'
    windows.vm.provision 'install-docker',
                         type: 'shell',
                         path: 'https://github.com/StefanScherer/packer-windows/raw/main/scripts/docker/install-docker.ps1',
                         env: { docker_version: '20.10.0' }
    # windows.vm.provision 'docker-pull',
    #                      type: 'shell',
    #                      path: 'https://github.com/StefanScherer/packer-windows/raw/main/scripts/docker/docker-pull.ps1',
    #                      # rubocop: disable Metrics/LineLength
    #                      env: { docker_images: 'mcr.microsoft.com/windows/nanoserver:1809 mcr.microsoft.com/windows/servercore:ltsc2019 mcr.microsoft.com/windows/servercore:1809 mcr.microsoft.com/windows:1809' }
    # rubocop: enable Metrics/LineLength

    windows.vm.provision 'open-docker-insecure-port.ps1',
                         type: 'shell',
                         path: 'https://github.com/StefanScherer/packer-windows/raw/main/scripts/docker/open-docker-insecure-port.ps1'
    windows.vm.provision 'install-calico'
  end
end
# rubocop:enable Metrics/BlockLength
