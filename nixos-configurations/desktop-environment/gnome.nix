{ config, lib, pkgs, options, ... }:


{

  # part of plasma package wrapping an application uses this (chromium, etc)
  nixpkgs.config.permittedInsecurePackages = [
    "electron-19.1.9"
  ];

  services = {
    avahi.enable = lib.mkDefault false;  # Media discovery not needed
    geoclue2.enable = lib.mkForce false;  # Location services not needed
    gnome = {
       games.enable = lib.mkDefault false;
       evolution-data-server.enable = lib.mkForce false;
    };

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
      defaultWindowManager = "/run/current-system/sw/bin/gnome-session";
      enable = true;
      openFirewall = true;
    };

    xserver = {
      enable = true;   # Enable the X11 windowing system.

      ## Desktop Manager
      desktopManager = {
        xterm.enable = false;
        gnome.enable = true;
      };

      ## Display Manager
      displayManager = {
        autoLogin.enable = false;
        defaultSession = "gnome";
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
      gnome.gnome-session
      xrdp
      gparted
      #gnome-menus

      gnomeExtensions.dash-to-panel
      gnomeExtensions.tray-icons-reloaded
      gnomeExtensions.vitals
    ]);

    # environment.gnome.exlcudePackages   EXCLUDE EXCLUDE EXCLUDE
    # Items that have no place on a dedicated server
    gnome.excludePackages = ( with pkgs; [
      # gnome-photos
      geoclue2
      gnome-tour
      snapshot
    ]) ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-calendar
      gnome-characters
      # gnome-color-manager
      gnome-contacts
      gnome-maps
      gnome-music
      gnome-terminal
      gnome-weather
      # gedit # text editor
      epiphany # web browser
      geary # email reader
      # evince # document viewer
      simple-scan
      totem
      yelp
    ]);
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    dconf = {
      enable = true;
      profiles = {
        user.databases = [{
          settings = with lib.gvariant; {
            "org/gnome/desktop".color-shading-type = "solid";
            "org/gnome/desktop/background".picture-options = "none";
            "org/gnome/desktop/background".picture-uri = "";
            "org/gnome/desktop/background".picture-uri-dark = "";
            "org/gnome/desktop/background".primary-color = "#111111";
            "org/gnome/desktop/interface" = {
              color-scheme = "prefer-dark";
              document-font-name = "Cantarell 12";
              enable-animations = false;
              monospace-font-name = "Source Code Pro 12";
              overlay-scrolling = false;
              text-scaling-factor = 1.0;
              scaling-factor = 1.0;
            };
            "org/gnome/desktop/media-handling" = {
                autorun-never = true;
                autorun-x-content-ignore = [ "x-content/unix-software" "x-content/image-dcf" "x-content/audio-player" "x-content/video-dvd" "x-content/audio-cdda" "x-content/audio-dvd" ];
            };
            "org/gnome/desktop/privacy".remember-recent-files = true;
            "org/gnome/desktop/session".idle-delay = mkUint32 600;
            "org/gnome/desktop/screensaver".lock-delay = mkUint32 30;
            "org/gnome/desktop/screensaver".picture-uri = "";
            "org/gnome/desktop/screensaver".picture-uri-dark = "";
            "org/gnome/desktop/wm/preferences".button-layout  = "appmenu:minimize,maximize,close";
            "org/gnome/desktop/wm/preferences".num-workspaces = "4";
            "org/gnome/nautilus/preferences".default-folder-viewer = "list-view";
            "org/gnome/nautilus/list-view" = {
              default-zoom-level = "small";
              default-column-order = [ "name" "size" "type" "owner" "group" "permissions" "date_modified" "where" "date_modified_with_time" "date_accessed" "date_created" "recency" "detailed_type" ];
              default-visible-columns = [ "name" "size" "date_modified" "where" ];
            };
            "org/gnome/shell" = {
              disable-user-extensions = false;

              # `gnome-extensions list` for a list
              enabled-extensions = [
                #"apps-menu@gnome-shell-extensions.gcampax.github.com"
                "trayIconsReloaded@selfmade.pl"
                "Vitals@CoreCoding.com"
                "dash-to-panel@jderose9.github.com"
                #"sound-output-device-chooser@kgshank.net"
                #"space-bar@luchrioh"
              ];

              favorite-apps = [ "org.gnome.Nautilus.desktop" "org.gnome.Console.desktop" "chromium-browser.desktop" "org.gnome.TextEditor.desktop" ];
            };
            "org/gnome/shell/extensions/dash-to-panel" = {
                panel-sizes = "{'0': 32}";
                panel-element-positions = ''
 '{"0":[{"element":"leftBox","visible":false,"position":"stackedTL"},{"element":"showAppsButton","visible":true,"position":"stackedTL"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"stackedTL"},{"element":"centerBox","visible":true,"position":"centered"},{"element":"dateMenu","visible":true,"position":"stackedBR"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedBR"},{"element":"desktopButton","visible":true,"position":"stackedBR"}]}'
'';
                secondarymenu-contains-showdetails = true;
            };
            "org/gnome/mutter" = {
               edge-tiling = true;
               attach-modal-dialogs = true;
               experimental-features = [ "scale-monitor-framebuffer" ];
            };

            "org/gnome/settings-daemon/plugins/media-keys" = {
              shutdown="";
              custom-keybindings=''
[  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" ]
'';
             };

            "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
              name="logout";
              command="/sbin/shutdown -h now";
              binding="<Control><Alt>Delete";
            };

            "org/gnome/settings-daemon/plugins/power" = {         # Suspend only on battery power, not while charging.
              sleep-inactive-ac-timeout = "0";
              sleep-inactive-ac-type = "nothing";
              sleep-button-action = "nothing";
              power-button-action = "interactive";
            };

            "org/gnome/system/location".enabled = false;

            "org.gnome.TextEditor" = {
              indent-style = "space";
              show-line-numbers = true;
              tab-width = "4";
            };
          };
        }];
      };
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

