
{ config, pkgs, lib, ... }:

with lib; {

  boot.loader.systemd-boot.enable = mkDefault true;
  boot.loader.systemd-boot.consoleMode =  mkDefault "1";
  boot.loader.efi.canTouchEfiVariables = mkDefault true;

# Enable networking
  networking.networkmanager.enable = mkDefault true;
  networking.networkmanager.wifi.powersave = mkDefault false;
  networking.enableIPv6 = mkDefault true;

  environment.systemPackages = mkIf (config.services.xserver.enable == true) [
    pkgs.gparted
    #pkgs.putty
    pkgs.freerdp

  ];

   nixpkgs.config.allowUnfree = true;

  systemd.sleep.extraConfig = mkDefault ''
    AllowSuspend=no
    AllowHibernation=no
  '';

}
