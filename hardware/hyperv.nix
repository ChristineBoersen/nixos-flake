
{ config, lib, pkgs, ... }:

with lib; {
  imports = [

  ];

   mkIf (virtualisation.hypervGuest.enable == true) {

      virtualisation.hypervGuest.videoMode = mkDefault "1600x900"

      boot.kernelParams = ["video=hyperv_fb:1600x900"];  # https://askubuntu.com/a/399960
      boot.kernel.sysctl."vm.overcommit_memory" = "1"; # https://github.com/NixOS/nix/issues/421;

      environment = {
        systemPackages  = (with pkgs; [

        ]);
      };
      nixpkgs.hostPlatform = lib.mkForce "x86_64-linux";
   };

}
