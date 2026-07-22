{ pkgs, ... }:
# image preview portion from:
# https://github.com/sentriz/cliphist/blob/master/contrib/cliphist-rofi-img
# nixpkg ships chiphist-rofi-img with the main package, btw.
let
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

        idx=$(cliphist list | gawk "$prog" | rofi -dmenu -p "theo's cliphist manager>" -i -show-icons \
          -mesg "<span size=\"small\">ESC to quit</span>" \
          -theme-str 'window {width: 800px;}' \
          -theme-str 'listview {columns: 1; lines: 20;}' \
          -theme-str 'textbox {horizontal-align: 0.5;}'
        )

        # Exit if no selection
        [[ -z "$idx" ]] && exit 0

        # filter out images
        if [[ "$idx" =~ binary.*(jpg|jpeg|png|bmp) ]]; then
            preview="<i>(pretty picture that unfortunately cannot be displayed ]</i>"$'\n'"Info: $idx"
        else
            preview=$(cliphist decode <<< "$idx" | tr -d '\0' | head -n 5 | cut -c 1-200 | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')
        fi

        # selection menu
        action=$(echo -e "back\ncopy\ndelete\nclear history" | rofi -dmenu -p ">" \
          -mesg "$preview" \
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
            cliphist decode <<< "$idx" | wl-copy
            exit 0
            ;;
          "delete")
            cliphist delete <<< "$idx"
            ;;
          "clear history")
            confirm=$(echo -e "Cancel\nBE GONE CLIPBOARD HISTORY" | rofi -dmenu -p "Confirm Wipe?" \
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
in
{
  home.packages = [ theo-cliphist-manager ];

  services.cliphist = {
    enable = true;
    systemdTargets = [ "niri.service" ];
  };
}
