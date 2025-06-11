{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ./../../base.nix ];

  networking = { hostName = "2b"; };

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  services.hardware.openrgb = {
    package = pkgs.openrgb-with-all-plugins;
    enable = true;
  };

  environment.systemPackages = with pkgs; [ i2c-tools ];
  hardware.i2c.enable = true;

  boot.blacklistedKernelModules = [ "spd5118" ];

}

