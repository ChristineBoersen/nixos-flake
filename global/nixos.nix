
{ config, pkgs, lib, ... }:

with lib; {

  boot.loader.systemd-boot.enable = mkDefault true;
  boot.loader.systemd-boot.consoleMode =  mkDefault "1";
  boot.loader.efi.canTouchEfiVariables = mkDefault true;

# Enable networking
  networking.networkmanager.enable = mkDefault true;
  networking.networkmanager.wifi.powersave = mkDefault false;
  networking.enableIPv6 = mkDefault true;

  environment = {
  # environment.etc
    etc = {    
          # use this section to insert items into the etc dir. The keyname is the filename without the /etc/ prepended to the path
    };
    
    systemPackages = mkIf (config.services.xserver.enable == true) [
      pkgs.gparted
      #pkgs.putty
      pkgs.freerdp
      pkgs.pam_u2f
    ];
  };

  nixpkgs.config.allowUnfree = true;

  services.udev.extraRules = ''
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0664", TAG+="uaccess"
'';

  systemd.sleep.extraConfig = mkDefault ''
    AllowSuspend=no
    AllowHibernation=no
  '';

}
