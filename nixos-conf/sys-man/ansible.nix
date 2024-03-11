# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running nixos-help).

{ config, lib, pkgs, options, ... }:

{
  networking.firewall.allowedTCPPorts = [ 3000 ];
  environment = {
  # environment.etc
    etc = {
      # use this section to insert items into the etc dir. The keyname is the filename without the /etc/ prepended to the path

    };

    systemPackages = (with pkgs; [
      ansible
      python3
      python311Packages.ansible-core


    ]);

  };


}
