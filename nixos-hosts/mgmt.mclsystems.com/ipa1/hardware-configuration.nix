# Do not modify this file!  It was generated by â€˜nixos-generate-configâ€™
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  boot.initrd.availableKernelModules = [ "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/fdd9ef33-ce20-4b8c-bb39-3501e5166c10";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/56E2-CA79";
      fsType = "vfat";
    };

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 4*1024;
  }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault false;
  networking.interfaces.eth0 = {
    mtu = 9000;
    ipv4 = {
      addresses = [
        {
          address = "10.250.0.4"
          prefixLength = 24;
        }
      ];
      routes = [
        {
          address = "10.250.0.0";
          prefixLength = 24;
        }
        {
          address = "0.0.0.0";       
          prefixLength = 0;
          via = "10.250.0.1";
        }
      ];
    };    
  };
  # networking.interfaces.eth0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  virtualisation.hypervGuest.enable = true;
}
 