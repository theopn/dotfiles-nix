{ lib, pkgs, ... }:

let
  myscripts = import ./waybar-scripts.nix { inherit pkgs; };
in
{
  programs.waybar = {
    enable = true;

    # make sure to launch niri with `niri-session` command
    systemd = {
      enable = true;
      targets = [ "niri.service" ];
    };


    settings = {
      mainBar = {
        id = "theo-waybar-niri";
        layer = "top";
        position = "top";
        height = 34;
        spacing = 1;

        modules-left= [
          "niri/workspaces"
          "custom/niri-workspace-rename"
          "niri/window"
        ];
        modules-center = [
          "custom/dunst"
          "clock"
        ];
        modules-right = [
          "temperature"
          "mpris"
          "pulseaudio"
          "backlight"
          "battery"
          "power-profiles-daemon"
          "idle_inhibitor"
          "keyboard-state"
          "custom/separator"
          "tray"
        ];

        # modules-left
        "niri/workspaces" = {
          format = "{index}:{name}";
        };

        "custom/niri-workspace-rename" = {
          format = "󰑕 ";
          tooltip = true;
          tooltip-format = "Rename Current Workspace";
          on-click = "${lib.getExe myscripts.theo-rofi-niri-workspace-rename}";
        };

        "niri/window" = {
          format = "{app_id}";
          max-length = 50;
          icon = true;
          swap-icon-label = false;
        };

        # modules-center
        "custom/dunst" = {
          format = "󰵛";
          tooltip = true;
          tooltip-format = "L: DND Manager / R: History Manager";
          on-click = "${lib.getExe myscripts.theo-rofi-dnd}";
          on-click-right = "${lib.getExe myscripts.theo-rofi-dunst-manager}";
        };

        clock = {
          format = "  {:%b %e %H:%M}";

          tooltip-format = "\t<big>{:%H:%M:%S}</big>\n\n<tt><small>{calendar}</small></tt>";

          calendar = {
            mode = "month";
            mode-mon-col = 3;
            weeks-pos = "left";
            on-click-right = "mode";
            iso-8601 = true;
            format = {
              weeks = "<span color='#d8dee9'><i>{}</i></span>";
              today = "<span color='#b48ead'><b><u>{}</u></b></span>";
            };
          };

          actions.on-click-right = "mode";
        };

        # modules-right
        temperature = {
          format = "{icon} {temperatureC}°C";
          format-icons = "";
        };

        mpris = {
          format = "{status_icon} {player_icon}";
          format-paused = "{status_icon} {player_icon}";
          on-click-middle = "";
          on-click-right = "";
          player-icons = {
            default = " ";
            firefox = " ";
            spotify = " ";
            chromium = " ";
            plasma-browser-integration = "󰾔 ";
            mpv = " ";
          };
          status-icons = {
            playing = "";
            paused = "";
          };
          max-length = 10;
        };

        pulseaudio = {
          format = "{icon} {volume}% {format_source}";

          format-muted = "󰝟 {format_source}";

          format-source = "";
          format-source-muted = "󰍭";

          format-bluetooth = "󰗾 ({icon}) {volume}% {format_source}";
          format-bluetooth-muted = "󰗿 ({icon}) {format_source}";

          format-icons = {
            headphone = " ";
            hands-free = "󱡒 ";
            headset = " ";
            phone = " ";
            portable = " ";
            car = " ";
            default = ["󰕿" "󰖀" "󰕾"];
          };
          on-click = "pavucontrol";
        };

        backlight = {
          format = "{icon} {percent}%";
          format-icons = [" " " " " " " " " " " " " " " " " "];
        };

        battery = {
          bat = "BAT1";
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰃨 {capacity}%";
          format-plugged = " {capacity}%";
          format-icons = [" " " " " " " " " "];
          tooltip-format = "{timeTo}";
          interval = 30;
        };

        power-profiles-daemon = {
          format = "{icon}";
          tooltip-format = "Power profile: {profile}\nDriver: {driver}";
          tooltip = true;
          format-icons = {
            default = " ";
            performance = " ";
            balanced = " ";
            power-saver = " ";
          };
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󰅶 ";
            deactivated = "󰾪 ";
          };
          tooltip-format-activated = "CAFFEINATED";
          tooltip-format-deactivated = "might fall asleep";
        };

        keyboard-state = {
          numlock = false;
          capslock = true;
          scrolllock = false;
          format = {
            numlock = "N {icon}";
            capslock = "{icon}";
          };
          format-icons = {
            locked = "󰪛 ";
            unlocked = "";
          };
          binding-keys = [ 29 69 70 ];
        };

        "custom/separator" = {
          format = "";
          tooltip = false;
          interval = "once";
        };

        tray = {
          icon-size = 20;
          spacing = 10;
        };
      };
    };

    style = ''
    /*
    * _      __          __              ______       __
    *| | /| / /__ ___ __/ /  ___ _____  / __/ /___ __/ /__
    *| |/ |/ / _ `/ // / _ \/ _ `/ __/ _\ \/ __/ // / / -_)
    *|__/|__/\_,_/\_, /_.__/\_,_/_/   /___/\__/\_, /_/\__/
    *            /___/                        /___/
    */

    /* Nord Color Palette */
    @define-color color00 #2e3440;
    @define-color color01 #3b4252;
    @define-color color02 #434c5e;
    @define-color color03 #4c566a;
    @define-color color04 #d8dee9;
    @define-color color05 #e5e9f0;
    @define-color color06 #eceff4;
    @define-color color07 #8fbcbb;
    @define-color color08 #88c0d0;
    @define-color color09 #81a1c1;
    @define-color color10 #5e81ac;
    @define-color color11 #bf616a;
    @define-color color12 #d08770;
    @define-color color13 #ebcb8b;
    @define-color color14 #a3be8c;
    @define-color color15 #ba8baf;

    * {
      font-family: "ProggyClean Nerd Font";
      font-size: 18px;
      border-radius: 12px;
    }

    window#waybar {
      margin: 10px 10px;
      background: rgba(46, 52, 64, 0.8);  /* @color00 */
      color: @color06;
    }


    /* Modules - Left */

    #workspaces {
      padding: 3px 3px;
    }

    #workspaces button {
      padding: 0px 9px 0px 9px;
      min-width: 1px;
    }

    #workspaces button.focused {
      color: @color00;
      background-color: @color06;
    }

    #workspaces button.urgent {
      background-color: @color11;
    }

    #custom-niri-workspace-rename {
      color: @color07;
      padding: 0px 1px 0px 1px;
    }

    #window {
      padding: 0px 10px 0px 10px;
      margin : 3px 3px;
    }

    window#waybar.empty #window {
      background-color: transparent;
      color: transparent;
    }


    /* Modules - Center */


    #custom-dunst {
      color: @color08;
      padding: 0px 5px;
      margin : 3px 3px;
    }

    #clock {
      padding: 0 5px;
      margin : 3px 3px;
    }


    /* Modules - Right */

    #temperature,
    #mpris, #pulseaudio,
    #backlight, #battery, #power-profiles-daemon, #idle_inhibitor,
    #tray
    {
      margin: 1px 1px;
      padding: 0 5px;
    }

    #mpris.playing{
      background-color: @color13;
    }

    #pulseaudio.muted {
      color: @color07
    }

    #battery.warning, #battery.critical {
      color: @color12;
    }

    #battery.charging, #battery.plugged {
      background-color: @color11;
    }

    #power-profiles-daemon {
      color: @color07;
    }

    #power-profiles-daemon.performance {
      background-color: @color11;
    }

    #power-profiles-daemon.power-saver {
      color: @color14;
    }

    #idle_inhibitor {
      color: @color07;
    }

    #idle_inhibitor.activated{
      background-color: @color11;
    }

    #keyboard-state label.locked {
      padding: 0 5px;
      color: @color14;
    }


    /* Tray */

    #custom-seperator {
      color: @color06;
      padding: 1px 1px;
    }

    #tray > .passive {
      -gtk-icon-effect: dim;
    }

    #tray > .needs-attention {
      -gtk-icon-effect: highlight;
      background-color: @color11;
    }
    '';
  };
}
