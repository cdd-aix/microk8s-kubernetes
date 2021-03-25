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
    wkube.vm.box = 'StefanScherer/windows_2019_docker'
    wkube.vm.provider 'virtualbox' do |v|
      v.gui = true
    end
    wkube.vm.provision 'install-kube-through-calico', type: 'shell', path: 'install-kube-via-calico.ps1'
  end
end
# rubocop:enable Metrics/BlockLength
