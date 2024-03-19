# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, fetchFromGitLab, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #./xfce-configuration.nix
      #./icewm-configuration.nix
      #./sway-configuration.nix
      ../../nixos-conf/desk-env/kde_plasma6.nix
      #../../nixos-conf/desk-env/gnome.nix
      #../../nixos-conf/desk-env/lxqt.nix
    ];


  services.avahi.enable = true;

  networking.hostName = "enterprise"; # Define your hostname.
  networking.domain = "starfleet.local";
  networking.extraHosts =
  ''
      192.168.1.83 drydock
      192.168.1.83 drydock.starfleet.local
  '';


  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.  Wireless may work via NM still

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  security.sudo.extraConfig = ''
    Defaults:ALL timestamp_timeout=15
    christine	ALL=(ALL) NOPASSWD: ALL
'';

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  sound.mediaKeys.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  #users.mutableUsers = false;
  users = {
    mutableUsers = false;
    users = {
      christine = {
        isNormalUser = true;
        description = "Christine Boersen";
        extraGroups = [ "networkmanager" "wheel" "dialout" "libvirt" ];
        packages = with pkgs; [

        ];
        hashedPasswordFile = "/etc/passwordFile-christine";
      };
      root.hashedPassword = "!";
    };
  };



  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #openrgb-with-all-plugins
    
    python3
    #cantarell-fonts
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
  
  # nixpkgs.overlays = [ (final: prev:   
  #   /* overlay goes here */  
  #   {
  #     openrgb = prev.openrgb.overrideAttrs (old: {
  #       src = prev.fetchFromGitLab {
  #         owner = "CalcProgrammer1";
  #         repo = "OpenRGB";
  #         rev = "5532e2e290a91527620fbc801fc9d4d94882a1b7";
  #         sha256 = "sha256-LCdQLv8K7AjBTXuVoiYGCzTpbnmlHxzz+2FhxbKcY7g=";
  #       };  
  #     });     
  #   })
  # ];

  

}
