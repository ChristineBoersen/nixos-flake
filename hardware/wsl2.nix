# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, nixos-wsl, ... }:

{
  imports = [
    # include NixOS-WSL modules
   
    nixos-wsl.nixosModules.wsl
  ];

  boot.loader.systemd-boot.enable = lib.mkForce false;  #wsl doesn't "boot" per se even with systemd enabled, this conflicts
  wsl.enable = true;
  wsl.defaultUser = "nixos";



  environment = {
    systemPackages  = (with pkgs; [    
      #nil  # Nixos Language Server
    ]);
  };

}
