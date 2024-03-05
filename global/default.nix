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


  environment.systemPackages = lib.mkIf (config.services.xserver.enable == true) [
      pkgs.putty
      pkgs.freerdp
    ];

}
