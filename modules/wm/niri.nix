{
  flake.modules.nixos.niri = {
    programs.niri = {
      enable = true;
      useNautilus = true;
    };
  };

  flake.modules.homeManager.niri = { lib, pkgs, ... }:
    let
      myscripts = import ./_niri-scripts.nix { inherit pkgs; };
    in
  {

    home.packages = with pkgs; [
      brightnessctl pavucontrol playerctl
      grim slurp sway-contrib.grimshot wf-recorder wl-clipboard-rs
      nautilus networkmanagerapplet
      xwayland-satellite
    ];


    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
      ];
      config.common.default = [ "gnome" "gtk" ];
    };

    services.gnome-keyring = {
      enable = true;
      # SSH keys are managed with `keychain` so no need
      components = [ "secrets" ];
    };

    # They finally added the Niri module and KDL config, rejoyce
    # https://github.com/nix-community/home-manager/pull/9685
    wayland.windowManager.niri = {
      enable = true;
      settings = {
        # === Input ===
        input = {
          keyboard = {
            xkb.options = "ctrl:swapcaps";
            repeat-delay = 300;
            repeat-rate = 33;
            numlock = {};
          };

          touchpad = {
            tap = {};
            dwt = {};
            natural-scroll = {};
            scroll-method = "two-finger";
          };

          # Focus follows iff the window is entirely on screen and not cut off
          focus-follows-mouse._props.max-scroll-amount = "0%";
        };

        # === Gestures, Overview, Cursor, etc. ===
        gestures.hot-corners.off = {};

        overview = {
          backdrop-color = "#2e3440"; # nord0
          workspace-shadow.off = {};
        };

        prefer-no-csd = {};

        cursor = {
          xcursor-theme = "Adwaita";
          xcursor-size = 24;
          hide-when-typing = {};
        };

        hotkey-overlay = {
          hide-not-bound = {};
          skip-at-startup = {};
        };

        screenshot-path = "~/Pictures/niri-screenshot-%Y-%m-%d-%H-%M-%S.png";

        animations.off = {};

        # Focus the window when xdg-portal opens a link
        debug.honor-xdg-activation-with-invalid-serial = {};

        # === Layout ===
        layout = {
          gaps = 7;
          center-focused-column = "never";

          # Mod+R presets
          preset-column-widths._children = [
            { proportion = 0.5; }
            { proportion = 0.33333; }
            { proportion = 0.66667; }
          ];

          # Makes half-splitting easy using Mod+F
          default-column-width.proportion = 0.5;

          # Mod+Shift+R presets
          preset-window-heights._children = [
            { proportion = 0.33333; }
            { proportion = 0.5; }
            { proportion = 0.66667; }
          ];

          # basically border for the focused window
          focus-ring = {
            width = 3;
            active-color = "#88c0d0";  # nord8
            inactive-color = "#4c566a"; # nord3
          };

          border.off = {};
          shadow.off = {};
          struts = {};

          tab-indicator = {
            on = {};
            place-within-column = {};
            gap = 5;
            width = 10;
            length._props.total-proportion = 1.0;
            position = "right";
            gaps-between-tabs = 5;
            corner-radius = 12;
            active-color = "#ebcb8b";   # nord13
            inactive-color = "#2e3440"; # nord0
            urgent-color = "#bf616a";   # nord11
          };
        };

        # === Keybindings ===
        binds = {
          "Mod+Shift+Slash".show-hotkey-overlay = {};

          # Opening programs
          "Mod+Return".spawn = [ "kitty" ];
          "Mod+Space".spawn = [ "rofi" "-show" "drun" ];
          "Mod+Shift+P" = {
            _props.hotkey-overlay-title = "Spawn `theo-rofi-powermenu`";
            spawn = [ "${lib.getExe myscripts.theo-rofi-powermenu}" ];
          };
          "Print".spawn = [ "${lib.getExe myscripts.theo-rofi-screenshot}" ];
          "Ctrl+Print".spawn = [ "${lib.getExe myscripts.theo-rofi-screenrecord}" ];
          "Shift+Print" = {
            _props.hotkey-overlay-title = "Spawn Niri screenshot";
            screenshot = {};
          };

          # custom cliphist manager, defined in cliphist.nix
          "Mod+Shift+V" = {
            _props.hotkey-overlay-title = "Spawn `theo-cliphist-manager`";
            spawn = [ "${lib.getExe myscripts.theo-cliphist-manager}" ];
          };
          # this one calls the official cliphist-rofi-img
          #"Mod+Shift+V".spawn = [ "rofi" "-modi" "clipboard:cliphist-rofi-img" "-show" "clipboard" "-show-icons" ];

          # Function keys
          "XF86AudioRaiseVolume" = { _props.allow-when-locked = true; spawn = [ "${lib.getExe myscripts.theo-volume-ctrl}" "up" ]; };
          "XF86AudioLowerVolume" = { _props.allow-when-locked = true; spawn = [ "${lib.getExe myscripts.theo-volume-ctrl}" "down" ]; };
          "XF86AudioMute" = { _props.allow-when-locked = true; spawn = [ "${lib.getExe myscripts.theo-volume-ctrl}" "mute" ]; };
          "XF86AudioMicMute" = { _props.allow-when-locked = true; spawn-sh = [ "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle" ]; };
          "XF86AudioPlay" = { _props.allow-when-locked = true; spawn-sh = [ "playerctl play-pause" ]; };
          "XF86AudioStop" = { _props.allow-when-locked = true; spawn-sh = [ "playerctl stop" ]; };
          "XF86AudioPrev" = { _props.allow-when-locked = true; spawn-sh = [ "playerctl previous" ]; };
          "XF86AudioNext" = { _props.allow-when-locked = true; spawn-sh = [ "playerctl next" ]; };
          "XF86MonBrightnessUp" = { _props.allow-when-locked = true; spawn = [ "${lib.getExe myscripts.theo-brightness-ctrl}" "up" ]; };
          "XF86MonBrightnessDown" = { _props.allow-when-locked = true; spawn = [ "${lib.getExe myscripts.theo-brightness-ctrl}" "down" ]; };

          # Window manager
          "Mod+O" = { _props.repeat = false; toggle-overview = {}; };
          "Mod+Shift+Q" = { _props.repeat = false; close-window = {}; };

          # Theo's keymap principle
          # HJKL: navigation within a monitor
          # Arrows: navigation across monitors
          "Mod+H".focus-column-left = {};
          "Mod+J".focus-window-down = {};
          "Mod+K".focus-window-up = {};
          "Mod+L".focus-column-right = {};

          "Mod+Shift+H".move-column-left = {};
          "Mod+Shift+J".move-window-down = {};
          "Mod+Shift+K".move-window-up = {};
          "Mod+Shift+L".move-column-right = {};

          "Mod+Left" = { _props.hotkey-overlay-title = "Focus Monitor Left"; focus-monitor-left = {}; };
          "Mod+Down".focus-monitor-down = {};
          "Mod+Up".focus-monitor-up = {};
          "Mod+Right".focus-monitor-right = {};

          "Mod+Shift+Left" = { _props.hotkey-overlay-title = "Move Column to Monitor Left"; move-column-to-monitor-left = {}; };
          "Mod+Shift+Down".move-column-to-monitor-down = {};
          "Mod+Shift+Up".move-column-to-monitor-up = {};
          "Mod+Shift+Right".move-column-to-monitor-right = {};

          "Mod+Ctrl+Left" = { _props.hotkey-overlay-title = "Move Workspace to Monitor Left"; move-workspace-to-monitor-left = {}; };
          "Mod+Ctrl+Down".move-workspace-to-monitor-down = {};
          "Mod+Ctrl+Up".move-workspace-to-monitor-up = {};
          "Mod+Ctrl+Right".move-workspace-to-monitor-right = {};

          "Mod+U".focus-workspace-down = {};
          "Mod+I".focus-workspace-up = {};
          "Mod+Ctrl+U".move-column-to-workspace-down = {};
          "Mod+Ctrl+I".move-column-to-workspace-up = {};

          "Mod+1".focus-workspace = 1;
          "Mod+2".focus-workspace = 2;
          "Mod+3".focus-workspace = 3;
          "Mod+4".focus-workspace = 4;
          "Mod+5".focus-workspace = 5;
          "Mod+6".focus-workspace = 6;
          "Mod+7".focus-workspace = 7;
          "Mod+8".focus-workspace = 8;
          "Mod+9".focus-workspace = 9;

          "Mod+Shift+1".move-column-to-workspace = 1;
          "Mod+Shift+2".move-column-to-workspace = 2;
          "Mod+Shift+3".move-column-to-workspace = 3;
          "Mod+Shift+4".move-column-to-workspace = 4;
          "Mod+Shift+5".move-column-to-workspace = 5;
          "Mod+Shift+6".move-column-to-workspace = 6;
          "Mod+Shift+7".move-column-to-workspace = 7;
          "Mod+Shift+8".move-column-to-workspace = 8;
          "Mod+Shift+9".move-column-to-workspace = 9;

          "Mod+BracketLeft".consume-or-expel-window-left = {};
          "Mod+BracketRight".consume-or-expel-window-right = {};

          "Mod+R".switch-preset-column-width = {};
          "Mod+Shift+R".switch-preset-window-height = {};
          "Mod+Ctrl+R".reset-window-height = {};
          "Mod+F".maximize-column = {};
          "Mod+Shift+F".fullscreen-window = {};

          "Mod+Minus" = { _props.hotkey-overlay-title = "Decrease Column Width"; set-column-width = "-10%"; };
          "Mod+Equal" = { _props.hotkey-overlay-title = "Increase Column Width"; set-column-width = "+10%"; };
          "Mod+Shift+Minus" = { _props.hotkey-overlay-title = "Decrease Window Height"; set-window-height = "-10%"; };
          "Mod+Shift+Equal" = { _props.hotkey-overlay-title = "Increase Window Height"; set-window-height = "+10%"; };

          "Mod+Shift+Space".toggle-window-floating = {};
          "Mod+Ctrl+Space".switch-focus-between-floating-and-tiling = {};
          "Mod+W" = { _props.hotkey-overlay-title = "Toggle Tabbed Display"; toggle-column-tabbed-display = {}; };

          "Mod+Escape" = { _props = { allow-inhibiting = false; hotkey-overlay-title = "Toggle Keyboard Shortcut Inhibitor"; }; toggle-keyboard-shortcuts-inhibit = {}; };
          "Super+Alt+L" = { _props = { allow-when-locked = true; hotkey-overlay-title = "Respwan Swaylock in case it ever dies"; }; spawn = [ "swaylock" ]; };
        };

        # _args for repeated/parameterized top-level nodes
        # See: https://home-manager-options.extranix.com/?query=niri&release=master
        _children = [

          {
            output = {
              _args = [ "eDP-1" ];
              # "mode" is automatically picked by Niri
              variable-refresh-rate = {};
              scale = 1.67;
              transform = "normal";
              # Place monitors to the right of the laptop
              position._props = { x = 0; y = 0; };
            };
          }

          # Startup
          # Niri spawns: dunst, waybar, nm-applet, cliphist, fcitx5, swaydile, and other services
          { spawn-sh-at-startup = "swaybg --mode fill --image ~/.local/share/theoshell/sway/wallpaper.png"; }

          # Named Workspaces
          { workspace._args = [ " " ]; }
          { workspace._args = [ " " ]; }
          { workspace._args = [ " " ]; }
          { workspace._args = [ " " ]; }

          # === Window Rules ===
          # default maximized, Mod+F to half-split
          { window-rule.open-maximized = true; }

          # pip
          {
            window-rule._children = [
              { match._props = { app-id = "firefox$"; title = "^Picture-in-Picture$"; }; }
              { match._props = { app-id = "librewolf$"; title = "^Picture-in-Picture$"; }; }
              { open-floating = true; }
            ];
          }

          # rounded corners
          {
            window-rule._children = [
              { geometry-corner-radius = 12; }
              { clip-to-geometry = true; }
            ];
          }

          # small windows
          {
            window-rule._children = [
              { match._props.app-id = "^org\\.pulseaudio\\.pavucontrol$"; }
              { match._props.app-id = "blueman-manager"; }
              { match._props.app-id = "^com\\.github\\.wwmm\\.easyeffects$"; }
              { open-floating = true; }
              { opacity = 0.8; }
              { default-column-width.fixed = 700; }
              { default-window-height.fixed = 700; }
            ];
          }

          # Blur introduced in 26.04
          {
            layer-rule._children = [
              { match._props.namespace = "waybar"; }
              { background-effect.blur = true; }
            ];
          }

          # I sometimes want to see what's behind when using rofi-calc
          {
            layer-rule._children = [
              { match._props.namespace = "^rofi$"; }
              { opacity = 0.77; }
              { background-effect = { xray = false; blur = false; }; }
            ];
          }
        ];
      };
    };

  }; # flake module (home-manager) ends


}
