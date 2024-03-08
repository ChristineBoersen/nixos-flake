{ config, lib, pkgs, options, ... }:


#let
#
#in
{

  # part of plasma package wrapping an application uses this (chromium, etc)
  nixpkgs.config.permittedInsecurePackages = [
    "electron-19.1.9"
  ];


  services = {
    dbus.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      #alsa.support32Bit = true;
      pulse.enable = true;   # See hardware.pulseaudio.enable
      # If you want to use JACK applications, uncomment this
      #jack.enable = false;
    };

    xrdp = {
      defaultWindowManager = "/run/current-system/sw/bin/plasma_session";
      enable = true;
      openFirewall = true;
    };

    xserver = {
      enable = true;   # Either X11 or Wayland

      ## Desktop Manager
      desktopManager = {
        xterm.enable = false;
        #plasma5.enable = false;
        plasma6 = {
          enable = true;
          enableQt5Integration = false;
        };
      };

      ## Display Manager
      displayManager = {
        autoLogin.enable = false;
        defaultSession = "plasma";
        gdm = {
          autoSuspend = false;
          enable = true;
          wayland = true;  # Keep matched to defaultsession (if false, plasmax11 would be the defaultSession)
          banner = "${config.networking.fqdnOrHostName}";
        };
        sessionCommands = ''
test -f ~/.xinitrc && . ~/.xinitrc
'';  # fixes bug where xinit isn't set correctly when homeManager isn't being used

      };


      xkb = {
        layout = "us";
        variant = "";
      };

    };

  };

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.login1.suspend" ||
            action.id == "org.freedesktop.login1.suspend-multiple-sessions" ||
            action.id == "org.freedesktop.login1.hibernate" ||
            action.id == "org.freedesktop.login1.hibernate-multiple-sessions")
        {
            return polkit.Result.NO;
        }
    });
  '';

#https://github.com/pjones/plasma-manager/issues/14

  systemd.services = {
    geoClue.enable = lib.mkForce false;  # No need
  };

  hardware.pulseaudio.enable = false;

  environment = {
    etc = {

    };   # etc end


    systemPackages = with pkgs ;
    [
      chromium
      plasma-pa
    ];

    plasma6.excludePackages = with pkgs; [
      #kdePackages.plasma-browser-integration
      #kdePackages.oxygen
      xwayland
      gnome.mutter
      gnome.gnome-shell
    ];

    # environment.gnome.exlcudePackages   EXCLUDE EXCLUDE EXCLUDE
    # Items that have no place on a dedicated server

  };


  #hardware.opengl.driSupport32Bit = true;


  security = {
    pam.services.gdm.enableGnomeKeyring = true;
    rtkit.enable = true;
  };

  users.users.gdm = {
    extraGroups = [ "video"];  # gdm locks up with blank screen on start without this with xRDP
  };
}


