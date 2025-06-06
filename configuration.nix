# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

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

  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };


  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  services.printing.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.displayManager = {
    defaultSession = "niri";
    sddm = {
      enable = true;
      wayland.enable = true;
    };
    autoLogin = {
      enable = true;
      user = "fabien";
    };
  };

  services = {
    syncthing = {
      enable = true;
      user = "fabien";
      configDir = "/home/fabien/.config/syncthing";
      dataDir = "/home/fabien/Sync";
    };
  };

  users.users.fabien = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      git
      git-lfs
      difftastic
      tailwindcss-language-server
      prettierd
      vscode-langservers-extracted
      taplo
      deno
      htop

      astro-language-server
      bun
      rust-analyzer
      svelte-language-server
      yaml-language-server
      ansible-language-server
      ansible

      # Backups
      rustic

      # Music
      beets

      # Video
      mpv

      # Editors
      helix
      neovim

      go
      gopls
      golangci-lint-langserver
      delve

      terraform-ls

      # Databases
      valkey
      postgresql

      # Images
      swww
      kitty
      wezterm
      oculante

      # Documents
      zathura

      fish
      atuin
      direnv
      starship
      zoxide
      poetry
      fd
      mcat
      ripgrep
      fzf
      lazygit
      eza

      opentofu

      nushell
      f3d
      blender

      nvd

      yt-dlp

      k9s
      fluxcd

      orca-slicer
    ];
  };

  programs.firefox.enable = true;
  programs.niri.enable = true;
  programs.thunar.enable = true;
  programs.hyprlock.enable = true;
  # programs.waybar.enable = true;
   

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    helix # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    gammastep
    wget
    tofi
    mc
    zellij
    waybar
    wireguard-tools
  ];

  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    maple-mono.NF
    maple-mono.Normal-NF
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  nix.gc = {
    automatic = true;
    dates = "12:30";
    options = "--delete-older-than 7d";
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}

