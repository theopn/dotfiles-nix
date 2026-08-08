{ pkgs, ... }:

# I prefix all the custom scripts with theo-
#       so that I can easily get auto-suggestion
#       + doesn't cause a conflict with existing cmds.
# I swear I'm not a narcissist.
{

  ##### Powermenu script (Mod+Shift+P) #####
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

  ##### Screenshot using grimshot (Prtsc) #####
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

      # window capture does not work in Niri, and I do not know which package provides ppm in NixOS
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

  ##### Screen recording using wf-recorder (Ctrl+Prtsc) #####
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

  ##### brightnessctl + dunst progress bar #####
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

  ##### wpctl + dunst progress bar #####
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

  ##### better cliphist history manager (Mod+Shift+V) #####
  # Niri provides cliphist-rofi-img binary (from the README suggestion),
  # but that one is pretty limited.
  # Reference:
  #     https://github.com/sentriz/cliphist/blob/master/contrib/cliphist-rofi-img
  theo-cliphist-manager = pkgs.writeShellApplication {
    name = "theo-cliphist-manager";
    runtimeInputs = with pkgs; [ cliphist wl-clipboard coreutils gawk gnused ];
    text = ''
      tmp_dir="/tmp/cliphist"

      # basically a hack that converts images into icons to display in Rofi
      read -r -d "" prog <<'EOF' || true
      /^[0-9]+\s<meta http-equiv=/ { next }
      match($0, /^([0-9]+)\s(\[\[\s)?binary.*(jpg|jpeg|png|bmp)/, grp) {
          system("echo " grp[1] "\\\t | cliphist decode >/tmp/cliphist/"grp[1]"."grp[3])
          print $0"\0icon\x1f/tmp/cliphist/"grp[1]"."grp[3]
          next
      }
      1
      EOF

      while true; do
        rm -rf "$tmp_dir"
        mkdir -p "$tmp_dir"

        selection=$(cliphist list | gawk "$prog" | rofi -dmenu -p "theo's cliphist manager>" -i -show-icons \
          -mesg "<span size=\"small\">ESC to quit</span>" \
          -theme-str 'element-icon { size: 64px; }' \
          -theme-str 'window {width: 800px;}' \
          -theme-str 'listview {columns: 1; lines: 10;}' \
          -theme-str 'textbox {horizontal-align: 0.5;}'
        )

        # Exit if no selection
        [[ -z "$selection" ]] && exit 0

        # filter out images
        if [[ "$selection" =~ binary.*(jpg|jpeg|png|bmp) ]]; then
            # this is really tedious, but here we go.
            # As you can see, regex is bad, so it will catch things like "[[ binary data something png ]] + illegal text".
            # E.g., imagine a really dumb dude copying this exact if block here.
            # So we have to perform the same filteration as the else block.
            # BUT DON'T USE `CLIPHIST DECODE` SINCE IT WILL SPIT OUT BINARY AND BAD THINGS WILL HAPPEN.
            filtered_selection=$(echo "$selection" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')
            preview="<i>&lt; insert pretty picture that cannot be displayed here :( &gt;</i>"$'\n\n'"$filtered_selection"
        else
            # || true because if `head` cuts the text, then cliphist decode throws SIGPIPE in future lines
            preview=$(cliphist decode <<< "$selection" | tr -d '\0' | head -n 20 | cut -c 1-200 | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g' || true)
        fi

        # menu
        action=$(echo -e "back\ncopy\ndelete\nnuclear weapon" | rofi -dmenu -p ">" \
          -mesg "<b><u>content (first 20 lines)</u></b>"$'\n\n'"$preview" \
          -markup-rows \
          -theme-str 'mainbox {children: [ "message", "listview" ];}' \
          -theme-str 'listview {columns: 4; lines: 1;}' \
          -theme-str 'textbox {horizontal-align: 0.5;}' \
          -theme-str 'element-text {horizontal-align: 0.5;}'
        )

        # Exit if ESC is pressed in the sub-menu
        [[ -z "$action" ]] && exit 0

        # 4. Handle the chosen action
        case "$action" in
          "copy")
            cliphist decode <<< "$selection" | wl-copy
            exit 0
            ;;
          "delete")
            cliphist delete <<< "$selection"
            ;;
          "nuclear weapon")
            confirm=$(echo -e "nvm\nBE GONE CLIPBOARD HISTORY" | rofi -dmenu -p "you sure?" \
              -theme-str 'window {width: 400px;}' \
              -theme-str 'listview {lines: 2; columns: 1;}'
            )
            [[ "$confirm" == "BE GONE CLIPBOARD HISTORY" ]] && cliphist wipe
            ;;
          "back")
            continue
            ;;
        esac
      done
    '';
  };

}
