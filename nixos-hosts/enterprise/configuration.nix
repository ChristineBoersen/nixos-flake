# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #./xfce-configuration.nix
      #./icewm-configuration.nix
      #./sway-configuration.nix
      ../../nixos-configurations/desktop-environment/kde_plasma6.nix
      #../../nixos-configurations/desktop-environment/swayfx.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };

  networking.hostName = "enterprise"; # Define your hostname.
  networking.extraHosts =
  ''
      192.168.1.83 drydock
      192.168.1.83 drydock.starfleet.local
  '';



  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;
  networking.enableIPv6 = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  security.sudo.extraConfig = ''
    Defaults:ALL timestamp_timeout=15
    christine	ALL=(ALL) NOPASSWD: ALL
'';


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  #users.mutableUsers = false;
  users.users.christine = {
    isNormalUser = true;
    description = "Christine Boersen";
    extraGroups = [ "networkmanager" "wheel" "dialout" "libvirt" ];
    packages = with pkgs; [

    ];
    #passwordFile = "/etc/passwordFile-christine";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.

    python3

    # Utilities

    # Virtualisation
    qemu_kvm
    virt-manager
    virtiofsd
    virtualbox


    etcher


    # WINE and Graphics utils
    wine #-wayland
    #vulkan-tools
    #clinfo
    #libsForQt5.kcalc
    #virtualgl
    #wayland-utils


    vscodium-fhs
    nil

    libreoffice

    prusa-slicer
    freecad
    blender
    openscad
    vscode-extensions.antyos.openscad


#  Games
    steam
  ];


  # List services that you want to enable:


  virtualisation = {
    libvirtd = {
      enable = true;
    };
  };


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;





}
