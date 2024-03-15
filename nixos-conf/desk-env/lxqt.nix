{ config, lib, pkgs, nix-colors, home-manager, options, ... }:


{

  imports = [
    nix-colors.homeManagerModules.default
    #home-manager.nixosModules.home-manager
  ];

  #programs.home-manager.enable = true;

  colorScheme = nix-colors.colorSchemes.catppuccin-macchiato;

  # part of plasma package wrapping an application uses this (chromium, etc)
  nixpkgs.config.permittedInsecurePackages = [
    "electron-19.1.9"
  ];

  services = {
    avahi.enable = lib.mkDefault false;  # Media discovery not needed
    #geoclue2.enable = lib.mkForce false;  # Location services not needed
    #gnome = {
    #   games.enable = lib.mkDefault false;
    #   evolution-data-server.enable = lib.mkForce false;
    #};

    pipewire = {
      enable = true;
      alsa.enable = true;
      # alsa.support32Bit = true;
      pulse.enable = true;  # Use pipewire OR pulseaudio . They can't both control sound at once. See hardware.pulseaudio.enable
      # If you want to use JACK applications, uncomment this
      # jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    xrdp = {
      defaultWindowManager = "/run/current-system/sw/bin/lxqt-session";
      enable = lib.mkDefault true;
      openFirewall = lib.mkDefault true;
    };

    xserver = {
      enable = true;   # Enable the X11 windowing system.

      ## Desktop Manager
      desktopManager = {
        xterm.enable = false;
        #gnome.enable = true;
        lxqt.enable = true;
      };

      ## Display Manager
      displayManager = {
        autoLogin.enable = false;
        defaultSession = "lxqt";
        gdm = {
          autoSuspend = false;
          enable = true;
          wayland = true;
          banner = "${config.networking.fqdnOrHostName}";
        };
        sessionCommands = ''
test -f ~/.xinitrc && . ~/.xinitrc
'';  # fixes bug where xinit isn't set correctly when homeManager isn't being used
      };
      excludePackages = [ pkgs.xterm ] ++ ( with pkgs.xorg; [
        xrandr

      ]);

       xkb = {
        layout = "us";
        variant = "";
      };
    };

  };

  systemd.services = {
    geoClue.enable = lib.mkForce false;  # No need
  };

  hardware.pulseaudio.enable = false;

  environment = {
    etc = {
      # Fixes issue with Gnome color manager asking for extra authentication upon xRDP login
      "polkit-1/localauthority/50-local.d/45-allow-colord.pkla".text = ''
[Allow Colord all Users]
Identity=unix-user:*
Action=org.freedesktop.color-manager.create-device;org.freedesktop.color-manager.create-profile;org.freedesktop.color-manager.delete-device;org.freedesktop.color-manager.delete-profile;org.freedesktop.color-manager.modify-device;org.freedesktop.color-manager.modify-profile
ResultAny=no
ResultInactive=no
ResultActive=yes
'';

    };   # etc end

    # environment.systemPackages   INCLUDE INCLUDE INCLUDE
    systemPackages = (with pkgs; [

      chromium

      xrdp

      wl-clipboard-x11   # terminal copy/paste from clipboard to wayland
    ]);

    # environment.gnome.exlcudePackages   EXCLUDE EXCLUDE EXCLUDE
    # Items that have no place on a dedicated server
    gnome.excludePackages = ( with pkgs; [
      # gnome-photos
      geoclue2

    ]);
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    dconf = {
      enable = true;
    };
  };

  security = {
    pam.services.gdm.enableGnomeKeyring = true;
    rtkit.enable = true;
  };

  users.users.gdm = {
    extraGroups = [ "video"];  # gdm locks up with blank screen on start without this
  };
}

