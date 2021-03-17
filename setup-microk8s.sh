#!/bin/bash -eu
# Shell good practices.
# Exit on unexpected non-zero exit codes (-e)
# Fail accessing undefined variables (-u)
set -o pipefail
# Fail is any part of a pipeline fails

# Shell scripts experience odd behavior if they are overwritten while running.
# A "main" function with an exit and calling the function at the end of the script reduces that possibility.
SetupMicroK8s() {
    snap install microk8s --classic
    exit 0
}
SetupMicroK8s "$@"
exit 1
