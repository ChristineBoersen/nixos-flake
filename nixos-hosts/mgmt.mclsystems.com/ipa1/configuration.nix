# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../../hardware/hyperv.nix
      ../../../nixos-conf/desk-env/kde_plasma6.nix
      #../../../nixos-conf/sys-man/freeipa.nix
    ];

  # Enable networking
  networking.hostName = lib.mkForce "ipa1"; # Define your hostname.
  networking.domain = "mgmt.mclsystems.com";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable sound with pipewire.
  sound.enable = lib.mkForce false;

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

    ]);
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    mutableUsers = false;
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



}
