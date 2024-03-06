
{ config, pkgs, lib, ... }:

{



  environment.systemPackages = lib.mkIf (config.services.xserver.enable == true) [
    pkgs.gparted
    pkgs.putty
    pkgs.freerdp

  ];


}
