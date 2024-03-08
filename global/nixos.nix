
{ config, pkgs, lib, ... }:

{

  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;
# Enable networking
  networking.networkmanager.enable = lib.mkDefault true;
  networking.networkmanager.wifi.powersave = lib.mkDefault false;
  networking.enableIPv6 = lib.mkDefault true;

  environment.systemPackages = lib.mkIf (config.services.xserver.enable == true) [
    pkgs.gparted
    pkgs.putty
    pkgs.freerdp

  ];

  systemd.sleep.extraConfig = lib.mkDefault ''
    AllowSuspend=no
    AllowHibernation=no
  '';

}
