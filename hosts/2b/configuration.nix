{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ./../../base.nix ];

  networking = { hostName = "2b"; };

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
}

