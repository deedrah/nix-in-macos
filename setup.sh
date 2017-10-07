#!/bin/sh

set -e

#curl https://nixos.org/nix/install | sh
travis_wait 30 nix-build -Q -A go  --cores 8
nix-env -iA nixpkgs.tree
nix-build -A go.x.text
#tree ./result-bin
nix-build -A go.x.text.out
tree ./result
nix-build
