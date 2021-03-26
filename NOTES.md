# Notes putting together a Windows Worker for MicroK8s

* Vagrant default route through NAT control interface breaks default config.
  * Fix, add dhclient exit hook to disable route by default and run a one off route delete
* It's unclear if microk8s needs kube-proxy nudged towards linux in the manifest... because 'kubectl get ds kube-proxy -n kube-system ' outputs nothing despite kube-proxy running
* Unclear where calico ipam block size is set... in the config.ps1 on Windows
* Unclear how to set pod network cidr for microk8s
* All of the above is garbage...  See https://discuss.kubernetes.io/t/add-a-windows-worker-node-to-microk8s/13782
