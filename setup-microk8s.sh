#!/bin/bash -eux
# Shell good practices.
# Exit on unexpected non-zero exit codes (-e)
# Fail accessing undefined variables (-u)
set -o pipefail
# Fail is any part of a pipeline fails

# Shell scripts experience odd behavior if they are overwritten while running.
# A "main" function with an exit and calling the function at the end of the script reduces that possibility.
SetupMicroK8s() {
    # Install Microk8s
    snap install microk8s --classic
    # Install calicoctl
    (cd /usr/local/bin; curl -f -s -S -L -O https://github.com/projectcalico/calicoctl/releases/download/v3.18.1/calicoctl; chmod 755 calicoctl)
    # Add vagrant to microk8s group
    adduser vagrant microk8s
    # Export kube config
    (mkdir -p ~/.kube; chmod 700 ~/.kube; microk8s config > ~/.kube/config)
    # Calico requires DNS service
    microk8s enable dns
    # Maybe this waits until microk8s is up
    microk8s status --wait-ready
    # Disable IPIP, windows does not support https://docs.projectcalico.org/getting-started/windows-calico/kubernetes/requirements
    calicoctl patch felixconfiguration default -p '{"spec":{"ipipEnabled":false}}'
    # Setup calicoctl affinity https://microk8s.io/docs/add-a-windows-worker-node-to-microk8s
    DATASTORE_TYPE=kubernetes KUBECONFIG=~/.kube/config calicoctl ipam configure --strictaffinity=true
    version=$(microk8s kubectl get node "$(hostname)" -o jsonpath='{.status.nodeInfo.kubeletVersion}')
    cleanversion="${version%-*}"
    cleanversion="${cleanversion#v}"
    echo "$cleanversion" > ~/.kube/version
    mkdir -p /vagrant/.kube
    cp -v ~/.kube/{config,version} /vagrant/.kube/
    exit 0
}
SetupMicroK8s "$@"
exit 1
