{ config, pkgs, ... }:

{


  if (pkgs.mkIf (system.xserver.enable == true)) {
     environment.systemPackages = with pkgs; [
         putty

     ];
  }


}
