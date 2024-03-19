{ config, pkgs, lib, ... }:

with lib; {

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [

    dig         # nslookup replacement (since legacy network tools are gone now)

    direnv      # used in building
    git

    mdr         # Markdown reader
    mc          # Midnight Commander tui/cli file management

    nano        # included by default, listed for clarity

    ntfs3g      # read/write ntfs volumes
    nvd         # nixos version diff tool

    openssl     # don't assume packages bring in their own

    usbutils
    unzip
    vim         # some products assume VI/VIM exists (VSCode)
    wget

  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    gnupg.agent =  mkDefault {
      enable = true;
      enableSSHSupport = true;
    };
    nano =  mkDefault {
      enable = true;
      nanorc = ''
        set jumpyscrolling
        set linenumbers
        set mouse
        set multibuffer
        set tabstospaces
        set tabsize 2
        set trimblanks
        set unix
'';
    };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

# Select internationalisation properties.
  i18n.defaultLocale = mkDefault "en_US.UTF-8";

  i18n.extraLocaleSettings = mkDefault {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone =  mkDefault "America/New_York";




  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
