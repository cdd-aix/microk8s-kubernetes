# This runs without error under winrm
$ErrorActionPreference = "Stop"
mkdir -force c:\k
copy -force c:\vagrant\.kube\config c:\k\config
cd \
Write-Output "*** Downloading calico installer"
Invoke-WebRequest https://docs.projectcalico.org/scripts/install-calico-windows.ps1 -OutFile c:\install-calico-windows.ps1
$kubeRawVersion = get-content "C:\vagrant\.kube\version"
$kubeVersion = $kubeRawVersion -replace "`n","" -replace "`r",""
# Note we are missing calico-system namespace
Write-Output "*** Using calico installer to install Kubernetes " $kubeVersion
c:\install-calico-windows.ps1 -DownloadOnly yes -KubeVersion $kubeVersion
