#!/usr/bin/env bash

set -e

sudo nixos-rebuild build --upgrade --flake '.#' "$@" && nvd diff /run/current-system result
sudo nixos-rebuild switch --flake '.#'
