#!/bin/bash -eu
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
    (mkdir -p ~/bin; cd ~/bin; curl -O -L  https://github.com/projectcalico/calicoctl/releases/download/v3.18.1/calicoctl; chmod 755 calicoctl)
    # Add vagrant to microk8s group
    useradd vagrant microk8s
    # Export kube config
    (mkdir -p ~/.kube; chmod 700 ~/.kube; microk8s config > ~/.kube/config)
    # Setup calicoctl affinity https://microk8s.io/docs/add-a-windows-worker-node-to-microk8s
    DATASTORE_TYPE=kubernetes KUBECONFIG=~/.kube/config calicoctl ipam configure --strictaffinity=true
    version=$(microk8s kubectl get node "$(hostname)" -o jsonpath='{.status.nodeInfo.kubeletVersion}')
    cleanversion="${version%-*}"
    cleanversion="${cleanversion#v}"
    echo "$cleanversion" > .kube/version
    cp -rv ~/.kube /vagrant/
    exit 0
}
SetupMicroK8s "$@"
exit 1
