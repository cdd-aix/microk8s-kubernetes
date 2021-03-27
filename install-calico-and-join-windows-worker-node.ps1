$ErrorActionPreference = "Stop"
Write-Output "*** Installing calico services.  This hangs while waiting for Calicoinitialization to finish"
set-psdebug -Trace 2
c:\CalicoWindows\install-calico.ps1
Write-Output "*** Install Kubernetes services"
c:\CalicoWindows\kubernetes\install-kube-services.ps1
Write-Output "*** Starting kubelet and kube-proxy"
Start-Service kubelet
Start-Service kube-proxy
