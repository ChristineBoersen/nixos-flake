# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../hardware/hyperv.nix
      #./gnome-configuration.nix
      ../../nixos-conf/sys-man/netbox-configuration.nix
      ../../nixos-conf/sys-man/ansible-configuration.nix
      #./ansible-semaphore-configuration.nix
      #./simple-nixos-mailserver-configuration.nix
      #./zabbix-configuration.nix
    ];


  boot.kernel.sysctl."vm.overcommit_memory" = "1"; # https://github.com/NixOS/nix/issues/421;


  # Enable networking
  networking.hostName = "man1"; # Define your hostname.
  networking.domain = "mclsystems.com";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable sound with pipewire.
  sound.enable = lib.mkForce false;

  security = {
#    pki.certificateFiles = [ "/var/lib/dc1-mclsystems-com.pem"   ];
#pki.certificates = [''
#mclsystems.com
#-----BEGIN CERTIFICATE-----
#MIIDszCCApugAwIBAgIQJfjglAyXdrdA8/Y53Hc4MTANBgkqhkiG9w0BAQ0FADBN
#MRMwEQYKCZImiZPyLGQBGRYDY29tMRowGAYKCZImiZPyLGQBGRYKTUNMU1lTVEVN
#UzEaMBgGA1UEAxMRTUNMU1lTVEVNUy1EQzEtQ0EwHhcNMjIwMzE3MjE0NTA1WhcN
#MjcwMzE3MjE1NTA1WjBNMRMwEQYKCZImiZPyLGQBGRYDY29tMRowGAYKCZImiZPy
#LGQBGRYKTUNMU1lTVEVNUzEaMBgGA1UEAxMRTUNMU1lTVEVNUy1EQzEtQ0EwggEi
#MA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDwbpL71D3LGkK4neAyjp21jTPI
#trXFC8jBu9nmuwRE7zoJ/kdmMzmbsS2LVvPnJau/uY5dks62EoYN/i89AqIhFt06
#CQjpKTRS9RTpq4NHXIOa8hfUmA3P+xrQvmuoCkj1tDd224xInLLWxdSp8qbklB+z
#wSgOicARByJfjrdnLhXzhu134Vv+9aB1jWaMuPT6n5iDQpOxcaW+eNhjwN4EEGql
#95E0X0l+iDOt0cQAgrC3YbZKt63bSQrV+iNrKrHGtMV7Esy9K/NC9uJKF9PYA3AB
#+9WqFKmtOUTH+QVQ7unw5C7kF1M7mcuOmG3WCt7q5gSrT8oqoUMQP1Nng2H1AgMB
#AAGjgY4wgYswEwYJKwYBBAGCNxQCBAYeBABDAEEwCwYDVR0PBAQDAgGGMA8GA1Ud
#EwEB/wQFMAMBAf8wHQYDVR0OBBYEFNiXrFXj0xGIxu+dZMy+P2AXQF5PMBIGCSsG
#AQQBgjcVAQQFAgMBAAEwIwYJKwYBBAGCNxUCBBYEFLjOdY+uNhjDJzBSNDYM2mkI
#NxYcMA0GCSqGSIb3DQEBDQUAA4IBAQAizdAY66cEU4BwTkairbCz1fu2UPiDP8cz
#/Y2gizW+YsMyvUYatH7dQFgmcroVo/T5nskIruQ8y89kAfTB1ro7u2VI/iRaxALg
#9oxODh3Tb4+UO+dDOlGYLSWM28Hnh+gtc1mLvs/KUiOg4OdWaEuEJWcttr6DZX8O
#+4/PfSYbh3aC42steVsO9CzxMzzMthAyotHiAkDQ2qkfA6QJCwkSHqdA4odoN2bA
#LKLt2pFrt+TctJDeo568OqUC0FiTlwV32+nrqNB2vqYPJZvvF81LrVyCBS46W8+T
#HnvAazEd4L98kwrCfTUSXjJ55GFWzDHR6Hki3MjW3kKLzxkuuR3M
#-----END CERTIFICATE-----
#
#''];
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
