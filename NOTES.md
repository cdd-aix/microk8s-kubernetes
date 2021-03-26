# Notes putting together a Windows Worker for MicroK8s

* Vagrant default route through NAT control interface breaks default config.
  * Fix, add dhclient exit hook to disable route by default and run a one off route delete
