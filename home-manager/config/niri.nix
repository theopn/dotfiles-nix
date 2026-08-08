{ lib, pkgs, ... }:

let
  theo-rofi-powermenu = pkgs.writeShellApplication {
    name = "theo-rofi-powermenu";
    runtimeInputs = with pkgs; [ rofi ];
    text = ''
      shutdown='   shutdown'
      reboot=' 󰜉  reboot'
      lock='   lock'
      suspend=' 󰤄  suspend'
      logout=' 󰗼  logout'
      yes='   yes'
      no=' 󰜺  no'

      shutdown_cmd='systemctl poweroff'
      suspend_cmd='systemctl suspend'
      reboot_cmd='systemctl reboot'
      lock_cmd='swaylock -f'
      exit_wm_cmd='niri msg action quit'

      function run_rofi_selection() {
        echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi -dmenu  \
            -p "󰐦 "                                                           \
            -mesg "Uptime: $(uptime)"
      }

      function run_rofi_confirmation() {
        echo -e "$yes\n$no" | rofi  \
          -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 250px;}' \
          -theme-str 'mainbox {children: [ "message", "listview" ];}' \
          -theme-str 'listview {columns: 2; lines: 1;}' \
          -theme-str 'element-text {horizontal-align: 0.5;}' \
          -theme-str 'textbox {horizontal-align: 0.5;}' \
          -dmenu \
          -p 'Confirmation' \
          -mesg 'Are you Sure?'
      }

      function confirm_then_run() {
        selected="$(run_rofi_confirmation)"
        if [[ "$selected" == "$yes" ]]; then
          if [[ $1 == '--shutdown' ]]; then
            $shutdown_cmd
          elif [[ $1 == '--reboot' ]]; then
            $reboot_cmd
          elif [[ $1 == '--logout' ]]; then
            $exit_wm_cmd
          fi
        else
          exit 0
        fi
      }

      function main() {
        chosen="$(run_rofi_selection)"
        case $chosen in
          "$lock") $lock_cmd ;;
          "$shutdown") confirm_then_run --shutdown ;;
          "$reboot") confirm_then_run --reboot ;;
          "$suspend") $suspend_cmd ;;
          "$logout") confirm_then_run --logout ;;
        esac
      }
      main
    '';
  };

  theo-rofi-screenshot = pkgs.writeShellApplication {
    name = "theo-rofi-screenshot";
    runtimeInputs = with pkgs; [ rofi grim sway-contrib.grimshot ];
    text = ''
      area_cp=' area (clipboard)'
      area='󰩭 area'
      screen='󰹑 screen'

      function run_rofi_selection() {
        echo -e "$area_cp\n$area\n$screen" | rofi -dmenu -p "Screenshot Type>" -mesg "Path: ~/Pictures"
      }

      # window does not work in Niri, I do not know which package provides ppm in NixOS
      function main() {
        chosen="$(run_rofi_selection)"
        case $chosen in
          "$area_cp") grimshot --notify copy area ;;
          "$area")    grimshot --notify save area ;;
          #"$window")  grimshot --notify save window ;;
          "$screen")  grimshot --notify save screen ;;
          #"$color")   notify-send "$(grim -g "$(slurp -p)" -t ppm - | magick - -format '%[pixel:p{0,0}]' txt:-)" ;;
        esac
      }
      main
    '';
  };

  theo-rofi-screenrecord = pkgs.writeShellApplication {
    name = "theo-rofi-screenrecord";
    runtimeInputs = with pkgs; [ rofi wf-recorder killall ];
    text = ''
      #!/usr/bin/env bash

      # Options
      stop='     stop recording'
      area='󰩭 +  area (no audio)'
      screen='󰹑 +  screen (no audio)'
      screen_audio='󰹑 +  screen with audio'

      function run_rofi_selection() {
        echo -e "$stop\n$area\n$screen\n$screen_audio" | rofi -dmenu -p "Screen Recording Action>"
      }

      function main() {
        chosen="$(run_rofi_selection)"
        out="$HOME/Pictures/record-$(date +'%Y-%m-%d--%H-%M-%S.mp4')"
        case "$chosen" in
          "$stop")          killall -s SIGINT wf-recorder && dunstify '[Screenrecorder] SIGINT sent!' ;;
          "$area")          wf-recorder -f "$out" -g "$(slurp)" ;;
          "$screen")        wf-recorder -f "$out" ;;
          "$screen_audio")  wf-recorder --audio -f "$out" ;;
        esac
      }

      main
    '';
  };

  theo-brightness-ctrl = pkgs.writeShellApplication{
    name = "theo-brightness-ctrl";
    runtimeInputs = with pkgs; [ brightnessctl dunst ];
    text = ''
      bar_color="#ebcb8b"

      # brightnessctl get --percentage is only avilable in Git version,
      # and they haven't done a release since 2024...
      function get_brightness() {
        max=$(brightnessctl max)
        current=$(brightnessctl get)
        echo $(( (current * 100 + max / 2) / max ))
      }

      function show_brightness_notif() {
        brightness=$(get_brightness)
        if [[ "$brightness" -le 25 ]]; then
          icon="󰃞 "
        elif [[ "$brightness" -le 50 ]]; then
          icon="󰃟 "
        elif [[ "$brightness" -le 75 ]]; then
          icon="󰃝 "
        else
          icon="󰃠 "
        fi

        dunstify --timeout=1000 --replace=696969 -u low         \
          "$icon Brightness: $brightness%"                      \
          -h int:value:"''${brightness}" -h string:hlcolor:"''${bar_color}"

      }

      case $1 in
        up)   brightnessctl set +5% ;;
        down) brightnessctl set 5%- ;;
        *)    echo "No argument specified" ;;
      esac

      show_brightness_notif
  '';
  };

  theo-volume-ctrl = pkgs.writeShellApplication {
    name = "theo-volume-ctrl";
    runtimeInputs = with pkgs; [ wireplumber dunst gawk ];
    text = ''
      bar_color="#88c0d0"
      function get_volume() {
        wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}'
      }
      function get_mute() {
        wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print ($3 == "[MUTED]" ? "yes" : "no")}'
      }
      function show_volume_notif() {
        volume=$(get_volume)
        mute=$(get_mute)
        if [[ $volume -eq 0 ]] || [[ $mute == "yes" ]] ; then
          volume_icon="󰖁  MUTED"
        elif [[ $volume -lt 50 ]]; then
          volume_icon="󰖀 "
        else
          volume_icon="󰕾 "
        fi
        dunstify --timeout=1000 --replace=6969 -u low         \
          "$volume_icon Volume: ''${volume}%"                 \
          -h int:value:"''${volume}" -h string:hlcolor:"''${bar_color}"
      }
      case $1 in
        up)   wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ ;;
        down) wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- ;;
        mute) wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
        *)    echo "No argument specified" ;;
      esac
      show_volume_notif
    '';
  };
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
          _props.hotkey-overlay-title = "Powermenu";
          spawn = [ "${lib.getExe theo-rofi-powermenu}" ];
        };
        "Print".spawn = [ "${lib.getExe theo-rofi-screenshot}" ];
        "Ctrl+Print".spawn = [ "${lib.getExe theo-rofi-screenrecord}" ];
        "Shift+Print" = {
          _props.hotkey-overlay-title = "Open Niri native screenshot";
          screenshot = {};
        };

        # custom cliphist manager, defined in cliphist.nix
        "Mod+Shift+V".spawn = [ "theo-cliphist-manager" ];
        # this one calls the official cliphist-rofi-img
        #"Mod+Shift+V".spawn = [ "rofi" "-modi" "clipboard:cliphist-rofi-img" "-show" "clipboard" "-show-icons" ];

        # Function keys
        "XF86AudioRaiseVolume" = { _props.allow-when-locked = true; spawn = [ "${lib.getExe theo-volume-ctrl}" "up" ]; };
        "XF86AudioLowerVolume" = { _props.allow-when-locked = true; spawn = [ "${lib.getExe theo-volume-ctrl}" "down" ]; };
        "XF86AudioMute" = { _props.allow-when-locked = true; spawn = [ "${lib.getExe theo-volume-ctrl}" "mute" ]; };
        "XF86AudioMicMute" = { _props.allow-when-locked = true; spawn-sh = [ "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle" ]; };
        "XF86AudioPlay" = { _props.allow-when-locked = true; spawn-sh = [ "playerctl play-pause" ]; };
        "XF86AudioStop" = { _props.allow-when-locked = true; spawn-sh = [ "playerctl stop" ]; };
        "XF86AudioPrev" = { _props.allow-when-locked = true; spawn-sh = [ "playerctl previous" ]; };
        "XF86AudioNext" = { _props.allow-when-locked = true; spawn-sh = [ "playerctl next" ]; };
        "XF86MonBrightnessUp" = { _props.allow-when-locked = true; spawn = [ "${lib.getExe theo-brightness-ctrl}" "up" ]; };
        "XF86MonBrightnessDown" = { _props.allow-when-locked = true; spawn = [ "${lib.getExe theo-brightness-ctrl}" "down" ]; };

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

        "Mod+Left" = { _props.hotkey-overlay-title = "Focus Monitor Left (+ other arrows)"; focus-monitor-left = {}; };
        "Mod+Down".focus-monitor-down = {};
        "Mod+Up".focus-monitor-up = {};
        "Mod+Right".focus-monitor-right = {};

        "Mod+Shift+Left" = { _props.hotkey-overlay-title = "Move Column to Monitor Left (+ other arrows)"; move-column-to-monitor-left = {}; };
        "Mod+Shift+Down".move-column-to-monitor-down = {};
        "Mod+Shift+Up".move-column-to-monitor-up = {};
        "Mod+Shift+Right".move-column-to-monitor-right = {};

        "Mod+Ctrl+Left" = { _props.hotkey-overlay-title = "Move Workspace to Monitor Left (+ other arrows)"; move-workspace-to-monitor-left = {}; };
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

}
