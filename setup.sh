#!/bin/sh

set -e

#curl https://nixos.org/nix/install | sh
nix-env -iA nixos.tree
nix-build -A go.x.text
tree ./result-bin
nix-build -A go.x.text.out
tree ./result
nix-build
