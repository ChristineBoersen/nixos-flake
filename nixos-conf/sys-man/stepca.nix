# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running nixos-help).

{ config, lib, pkgs, options, ... }:

{
  networking.firewall.allowedTCPPorts = [  ];

  # broken package
  #nixpkgs.config.allowBroken = true;

  environment = {
  # environment.etc
    etc = {
      # use this section to insert items into the etc dir. The keyname is the filename without the /etc/ prepended to the path

    };

    systemPackages = (with pkgs; [
     step-ca
     step-cli


    ]);

  };

  services.step-ca = {
    enable = lib.mkDefault false;
    address = "10.240.0.8";
    port = 443;
    intermediatePasswordFile = "/run/keys/imca_ipa1_mgmt_mclsystems_com.pwd";
    settings = (builtins.fromJSON "/root/.step/config/ca.json");
  };

#   security.ipa = {
#     enable = lib.mkDefault true;
#     domain = "${config.networking.domain}";
#     realm = "${lib.strings.toUpper config.networking.domain}";
#     server = "${config.networking.fqdn}";
#     basedn = lib.concatStringsSep ", "  (lib.forEach (lib.splitString "." "${config.networking.domain}") (name: "DC=${name}")); # convert domain to distinguished name
#     #certificate = builtins.readFile /run/keys/root_ca.crt;
#     certificate = pkgs.fetchurl {
#       url = "http://${config.networking.fqdn}/config/ca.crt";  # "file://run/keys/root_ca.crt";  #
#       sha256 = "";
#     };
#   };
  

}
