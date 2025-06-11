{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./../../base.nix
    ];

  networking = {
    hostName = "eost-0404";
    interfaces.eno1.ipv4.addresses = [{
      address = "130.79.9.178";
      prefixLength = 22;
    }];
    defaultGateway = {
      address = "130.79.11.254";
      interface = "eno1";
    };
    nameservers = [
      "130.79.200.200"
      "1.1.1.1"
    ];
    wg-quick.interfaces = {
      datacenter = {
        configFile = "/etc/wireguard/datacenter.conf";
      };
    };
  };

  services.printing.enable = true;
}

