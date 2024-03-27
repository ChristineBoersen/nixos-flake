# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix      
    ];

  # Allows flakes (think currated package of packages + version lock , similar to node.js packages.json.lock
  nix.settings.experimental-features = [ "nix-command" "flakes" "ca-derivations" ];

  # Set networking
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

   
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  

  # Enable networking
  networking.hostName = ""; # Define your hostname.
  networking.domain = "";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable sound with pipewire.
  sound.enable = lib.mkForce false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    mtr.enable = true;
    nano = {
      enable = true;
      nanorc = ''
        set tabstospaces
        set tabsize 4
        set linenumbers
        set trimblanks
        set unix
'';
    };
  };

  security = {
    sudo.extraConfig = ''
    Defaults:ALL timestamp_timeout=15
    mcladmin  ALL=(ALL) NOPASSWD: ALL
'';   # extends defalt sudo timeout


  };


  services = {
    avahi.enable = lib.mkForce false;  # Media discovery not needed
    openssh.enable = lib.mkForce true; # Enable the OpenSSH daemon.
    printing.enable = false;    # Change to True to Enable CUPS to print documents.
    timesyncd.servers = [ "10.2.0.164" "10.2.0.126" ];    # Override hard coded nixos NTP servers
  };

  # Set your time zone.
  time.timeZone = "America/New_York";


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    # environment.etc
    etc = {
          # use this section to insert items into the etc dir. The keyname is the filename without the /etc/ prepended to the path
    };

    # environment.systemPackages   INCLUDE INCLUDE INCLUDE  #Add your packages here
    systemPackages = (with pkgs; [
        wget
        git  
        mdr # Markdown reader
        nvd
        direnv  # used in building
        openssl
    ]);
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users = {
      mcladmin = {
        isNormalUser = true;
        description = "mcladmin";
        extraGroups = [  "networkmanager" "wheel" "video" ];  # For an interactive user to logon, they need networkmanager and video.  wheel is needed for SUDO permission, colord to eliminate prompt upon loging to Gnome
        packages = with pkgs; [
            # Any user specific packages

        ];
        passwordFile = "/etc/passwordFile-mcladmin";  # Gets prompted for during install.sh
      };
      root.hashedPassword = "!";
    };
  };

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
