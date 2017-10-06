#!/bin/sh

set -e

#curl https://nixos.org/nix/install | sh
nix-build -A go '<nixpkgs>'
