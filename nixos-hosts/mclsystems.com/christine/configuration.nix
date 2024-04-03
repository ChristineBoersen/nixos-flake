# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{
  imports = [
    # WSL doesn't need a hardware-configuration.nix since it shares resources with host
    #./hardware-configuration.nix
    # include NixOS-WSL modules
    ../../../hardware/wsl2.nix
  ];


  environment = {
    systemPackages  = (with pkgs; [
      nil  # Nixos Language Server
    ]);
  };


}
