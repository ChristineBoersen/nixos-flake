
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
      "udev/rules.d/50-thetisu2f.rules".text = ''
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0664", GROUP="plugdev"'
'';
          # use this section to insert items into the etc dir. The keyname is the filename without the /etc/ prepended to the path
    };
    
    systemPackages = mkIf (config.services.xserver.enable == true) [
      pkgs.gparted
      #pkgs.putty
      pkgs.freerdp

    ];
  };

  nixpkgs.config.allowUnfree = true;

  systemd.sleep.extraConfig = mkDefault ''
    AllowSuspend=no
    AllowHibernation=no
  '';

}
