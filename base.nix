{ config, lib, pkgs, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "steam" "steam-unwrapped" ];

  # Set your time zone.
  time.timeZone = "Europe/Paris";

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
    extraGroups = [ "dialout" "wheel" ]; # Enable ‘sudo’ for the user.
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

      killall

      aria2

      python313Packages.meshtastic

      astro-language-server
      bun
      rust-analyzer
      svelte-language-server
      yaml-language-server
      ansible-language-server
      ansible

      libreoffice-qt-fresh
      hunspell
      hunspellDicts.fr-any

      imagemagick
      gimp3

      nil
      nixd
      nixfmt-classic

      # Backups
      rustic

      # Music
      beets

      # Video
      mpv

      # Editors
      helix
      neovim

      localsend

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
      kubectl
      fluxcd

      chromium

      orca-slicer
    ];
  };

  programs.firefox.enable = true;
  programs.niri.enable = true;
  programs.thunar.enable = true;
  programs.hyprlock.enable = true;

  environment.systemPackages = with pkgs; [
    appimage-run
    helix
    gammastep
    dua
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

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 53317 ];
    allowedUDPPorts = [ 53317 ];
  };

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

