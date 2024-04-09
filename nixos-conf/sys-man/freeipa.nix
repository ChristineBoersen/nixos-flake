# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running nixos-help).

{ config, lib, pkgs, options, ... }:

{
  networking.firewall.allowedTCPPorts = [  ];
  environment = {
  # environment.etc
    etc = {
      # use this section to insert items into the etc dir. The keyname is the filename without the /etc/ prepended to the path

    };

    systemPackages = (with pkgs; [
     freeipa


    ]);

  };

  security.ipa = {
    enable = lib.mkDefault true;
    domain = "${config.networking.domain}";
    realm = "${lib.strings.toUpper config.networking.domain}";
    server = "${config.networking.fqdn}";
    #certificate = builtins.readFile /run/keys/root_ca.crt;
    certificate = pkgs.fetchurl {
      url = "http://${config.networking.fqdn}/config/ca.crt";
      sha256 = "";
    };
  };
  

}
