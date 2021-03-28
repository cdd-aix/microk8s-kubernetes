# rubocop:disable Metrics/BlockLength
Vagrant.configure('2') do |config|
  config.vagrant.plugins = ['vagrant-reload']
  config.vm.provider 'virtualbox' do |v|
    v.linked_clone = true
    v.check_guest_additions = false
    v.customize ['modifyvm', :id, '--nested-hw-virt', 'on']
  end
  config.vm.define 'kube1' do |kube|
    kube.vm.hostname = 'kube1'
    kube.vm.network 'public_network',
                    use_dhcp_assigned_default_route: true,
                    bridge: ['eno1']
    kube.vm.box = 'bento/ubuntu-20.04'
    # microk8s config shows server based off of first interface with default route.  Disable the vagrant one
    kube.vm.provision 'disable-eth0-default-route',
                      type: 'file',
                      source: 'disable-eth0-default-route.sh',
                      destination: 'disable-eth0-default-route.sh'
    kube.vm.provision 'purge-eth0-default-now', type: 'shell', inline: <<-SHELL
  cp -pv disable-eth0-default-route.sh /etc/dhcp/dhclient-exit-hooks.d/
  ip route | awk '$1=="default"&&$5=="eth0"{print "ip route delete default via",$3}' | sh -x
SHELL
    kube.vm.provision 'setup-microk8s', type: 'shell', path: 'setup-microk8s.sh'
  end
  config.vm.define 'wkube1' do |wkube|
    # Should be a stripped down Windows server for size.  This works for a demo
    wkube.vm.hostname = 'wkube1'
    wkube.vm.network 'public_network',
                     use_dhcp_assigned_default_route: true,
                     bridge: ['eno1']
    wkube.vm.box = 'StefanScherer/windows_2019_docker'
    wkube.vm.provider 'virtualbox' do |v|
      v.gui = true
    end
    # wkube.vm.provision 'install-chocolatey', type: 'shell', path: 'install-chocolatey.ps1'
    wkube.vm.provision 'fetch-calico-installer', type: 'shell', path: 'fetch-calico-installer.ps1'
    # wkube.vm.provision 'windows-node',
    #                    type: 'shell', path: 'install-calico-and-join-windows-worker-node.ps1',
    #                    privileged: false
    # wkube.vm.provision 'install-calico', type: 'shell', inline: 'set-psdebug -Trace 2; & c:\CalicoWindows\install-calico.ps1'
    wkube.vm.provision 'kludged-installer', type: 'shell', inline: 'copy c:\vagrant\install-calico.ps1 c:\CalicoWindows\install-calico-kludge.ps1 -Force'
    wkube.vm.provision 'run-installer', type: 'shell', inline: 'c:\CalicoWindows\install-calico-kludge.ps1'
    wkube.vm.provision 'install-kube-services', type: 'shell', inline: 'c:\CalicoWindows\kubernetes\install-kube-services.ps1; Start-Service kubelet; Start-Service kube-proxy'
  end
end
# rubocop:enable Metrics/BlockLength
