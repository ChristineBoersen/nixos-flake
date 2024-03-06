{ config, pkgs, lib, ... }:

{


  environment.systemPackages = with pkgs; [

    direnv  # used in building
    git

    nano  # included by default, listed for clarity

    mdr # Markdown reader
    mc  # Midnight Commander tui/cli file management
    nvd  # nixos version diff tool

    openssl  # don't assume packages bring in their own
    dig      # nslookup replacement (since legacy network tools are gone now)
    ntfs3g   # read/write ntfs volumes

    unzip
    usbutils
    vim   # some products assume VI/VIM exists (VSCode)
    wget

  ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    nano = {
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





  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
