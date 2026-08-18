{ pkgs, ... }:
{
  ##### Renaming current Rofi Workspace #####
  theo-rofi-niri-workspace-rename = pkgs.writeShellApplication {
    name = "theo-rofi-niri-workspace-rename";
    runtimeInputs = with pkgs; [ rofi ];
    text = ''
      rename='󰑕 rename'
      reset='󰬟 reset'
      cancel='󰜺 cancel'
      function run_rofi_selection() {
        echo -e "$rename\n$reset\n$cancel" | rofi -dmenu -p ">" -mesg "Changing Current Workspace Name"
      }
      function get_name() {
        echo "" | rofi -dmenu -p "Enter Workspace Name:" -l 0
      }
      function main() {
        chosen="$(run_rofi_selection)"
        case $chosen in
          "$rename") niri msg action set-workspace-name "$(get_name)" ;;
          "$reset")  niri msg action unset-workspace-name ;;
        esac
      }
      main
    '';
  };

  ##### Controlling Dunst status #####
  theo-rofi-dnd = pkgs.writeShellApplication {
    name = "theo-rofi-dnd";
    runtimeInputs = with pkgs; [ rofi dunst ];
    text = ''
      on_action=' Pause Notification'
      off_action=' Resume Notification'

      if ! pgrep -x "dunst" > /dev/null && ! pgrep -x ".dunst-wrapped" > /dev/null; then
        # -modi run to prevent loading other plugins
        rofi -modi run -e 'Dunst not running :(' \
          -theme-str 'window {height: 150px; width: 400px;}' \
          -theme-str 'textbox {horizontal-align: 0.5; vertical-align: 0.5;}'
        exit 1
      fi

      current=' You are being disturbed'
      toggle="$on_action"
      if [[ $(dunstctl is-paused) == 'true' ]]; then
        current=" You are missing out on $(dunstctl count waiting) notifications"
        toggle="$off_action"
      fi

      action=$(echo -e "$toggle" | rofi -dmenu \
        -theme-str 'window {height: 150px; width: 400px;}' \
        -theme-str 'mainbox {children: [ "message", "listview" ];}' \
        -theme-str 'listview {columns: 1;}' \
        -theme-str 'element-text {horizontal-align: 0.5;}' \
        -theme-str 'textbox {horizontal-align: 0.5;}' \
        -mesg "$current")

      if [[ "$action" == "$on_action" ]]; then
        dunstctl set-paused true
      elif [[ "$action" == "$off_action" ]]; then
        dunstctl set-paused false
      fi
    '';
  };

  ##### Dunst history manager #####
  theo-rofi-dunst-manager = pkgs.writeShellScriptBin "theo-rofi-dunst-manager" ''
    function replace_special_char() {
      # replace & < > since Rofi throws Pango error with them
      echo "$1" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g'
    }

    function get_notif_list() {
      local uptime=$(awk '{print $1}' /proc/uptime)

      echo "$HIST_JSON" | jq -r --arg uptime "$uptime" '
      .data[0][] |
        (($uptime | tonumber) - (.timestamp.data / 1000000)) as $age |
        (
          if $age < 60 then "\($age | floor)s"
          elif $age < 3600 then "\($age / 60 | floor)m"
          elif $age < 86400 then "\($age / 3600 | floor)h"
          else "\($age / 86400 | floor)d"
          end
        )
        as $time |
          "<span size=\"small\">[\($time)]</span> <b>\(.appname.data | @html)</b>: \(.summary.data | gsub("\n"; " ") | @html)"
      '
    }

    function set_shell_var() {
      echo "$HIST_JSON" | jq -r --argjson idx "$1" '
      .data[0][$idx] |
        "ID=\(.id.data) APP=\(.appname.data | @sh) SUMMARY=\(.summary.data | @sh) BODY=\(.body.data | @sh) URGENCY=\(.urgency.data | @sh)"
      '
    }

    function warn_dunst_duplicate_id() {
      echo -e "gotcha\nback" | rofi -dmenu  --markup-rows           \
        -theme-str 'mainbox {children: [ "message", "listview" ];}' \
        -theme-str 'listview {columns: 2; lines: 1;}'               \
        -theme-str 'textbox {horizontal-align: 0.5;}'               \
        -theme-str 'element-text {horizontal-align: 0.5;}'          \
        -mesg '[FYI] Dunst will pick the <i>oldest</i> notification with the same ID, which might not be this one.'
    }

    ##### main execution #####

    if ! pgrep -x "dunst" > /dev/null && ! pgrep -x ".dunst-wrapped" > /dev/null; then
      # -modi run to prevent loading other plugins
      rofi -modi run -e 'Dunst not running :(' \
        -theme-str 'window {height: 150px; width: 400px;}' \
        -theme-str 'textbox {horizontal-align: 0.5; vertical-align: 0.5;}'
      exit 1
    fi

    while true; do
      HIST_JSON=$(dunstctl history)

      # -format i to return index as an output instead of str
      # -i for case insensitivity
      idx=$(get_notif_list | rofi -dmenu -p "History>" -markup-rows -format i -i  \
        -mesg "<span size=\"small\">ESC to quit</span>"     \
        -theme-str 'window {height: 800px; width: 800px;}'  \
        -theme-str 'listview {columns: 1;}'                 \
        -theme-str 'textbox {horizontal-align: 0.5;}'       \
      )
      # Exit if no selection
      [[ -z "$idx" ]] && exit 0

      # set variables with jq
      eval $(set_shell_var "$idx")

      msg="<b>App:</b> $(replace_special_char "$APP")
    <b>ID:</b> "$ID" | <b>Urgency:</b> "$URGENCY"
    <b>Summary:</b> $(replace_special_char "$SUMMARY")
    $(replace_special_char "$BODY")
      "
      action=$(echo -e "back\ndelete\ndisplay" | rofi -dmenu -p ">" \
        -mesg "$msg" \
        -markup-rows \
        -theme-str 'mainbox {children: [ "message", "listview" ];}' \
        -theme-str 'listview {columns: 3; lines: 1;}'               \
    )

      if [[ -z "$action" ]]; then
        exit 0
      elif [[ "$action" == "delete" ]]; then
        warn_confirm=$(warn_dunst_duplicate_id)
        [[ "$warn_confirm" == "gotcha" ]] && dunstctl history-rm "$ID"
      elif [[ "$action" == "display" ]]; then
        warn_confirm=$(warn_dunst_duplicate_id)
        [[ "$warn_confirm" == "gotcha" ]] && dunstctl history-pop "$ID"
      fi

    done
  '';
}
