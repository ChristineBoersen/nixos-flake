
{ config, lib, pkgs, ... }:

{
  imports = [
    
  ];

   lib.mkIf (virtualisation.hypervGuest.enable == true) {
      virtualisation.hypervGuest.videoMode = lib.mkDefault "1600x900"
      boot.kernelParams = ["video=hyperv_fb:1600x900"];  # https://askubuntu.com/a/399960
      boot.kernel.sysctl."vm.overcommit_memory" = "1"; # https://github.com/NixOS/nix/issues/421;
  
      environment = {
        systemPackages  = (with pkgs; [    
          
        ]);
      };

   };
  
}
