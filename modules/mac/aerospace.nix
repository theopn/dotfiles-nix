{
  flake.modules.darwin.aerospace = { pkgs, ... }: {
    services.aerospace = {
      enable = true;
      settings = {
        enable-normalization-flatten-containers = true;
        enable-normalization-opposite-orientation-for-nested-containers = true;
        accordion-padding = 50;
        default-root-container-layout = "tiles";
        default-root-container-orientation = "auto";
        on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];
        automatically-unhide-macos-hidden-apps = false;

        key-mapping.preset = "qwerty";

        gaps = {
          inner.horizontal = 5;
          inner.vertical = 5;
          outer.left = 5;
          outer.bottom = 5;
          outer.top = 5;
          outer.right = 5;
        };

        mode.main.binding = {
          "alt-shift-space" = "layout floating tiling";
          "alt-enter" = "exec-and-forget ${pkgs.kitty}/bin/kitty";

          "alt-e" = "layout tiles horizontal vertical";
          "alt-w" = "layout accordion horizontal vertical";

          "alt-h" = "focus left";
          "alt-j" = "focus down";
          "alt-k" = "focus up";
          "alt-l" = "focus right";

          "alt-shift-h" = "move left";
          "alt-shift-j" = "move down";
          "alt-shift-k" = "move up";
          "alt-shift-l" = "move right";

          "alt-minus" = "resize smart -50";
          "alt-equal" = "resize smart +50";

          "alt-1" = "workspace 1";
          "alt-2" = "workspace 2";
          "alt-3" = "workspace 3";
          "alt-4" = "workspace 4";
          "alt-5" = "workspace 5";
          "alt-6" = "workspace 6";
          "alt-7" = "workspace 7";
          "alt-8" = "workspace 8";
          "alt-9" = "workspace 9";
          "alt-shift-1" = "move-node-to-workspace 1";
          "alt-shift-2" = "move-node-to-workspace 2";
          "alt-shift-3" = "move-node-to-workspace 3";
          "alt-shift-4" = "move-node-to-workspace 4";
          "alt-shift-5" = "move-node-to-workspace 5";
          "alt-shift-6" = "move-node-to-workspace 6";
          "alt-shift-7" = "move-node-to-workspace 7";
          "alt-shift-8" = "move-node-to-workspace 8";
          "alt-shift-9" = "move-node-to-workspace 9";

          "alt-tab" = "workspace-back-and-forth";
          "alt-shift-tab" = "move-workspace-to-monitor --wrap-around next";

          "alt-shift-semicolon" = "mode service";
        };

        mode.service.binding = {
          "esc" = [ "reload-config" "mode main" ];
          "r" = [ "flatten-workspace-tree" "mode main" ];
          "alt-shift-h" = [ "join-with left" "mode main" ];
          "alt-shift-j" = [ "join-with down" "mode main" ];
          "alt-shift-k" = [ "join-with up" "mode main" ];
          "alt-shift-l" = [ "join-with right" "mode main" ];
        };

        on-window-detected = [
          {
            "if".app-id = "com.spotify.client";
            run = "move-node-to-workspace 9";
          }
          {
            "if".window-title-regex-substring = "Picture-in-Picture";
            run = [ "layout floating" ];
          }
          {
            "if".app-id = "com.apple.finder";
            run = "layout floating";
          }
          {
            "if".app-id = "com.apple.Preview";
            run = "layout floating";
          }
          {
            "if".app-id = "com.apple.QuickTimePlayerX";
            run = "layout floating";
          }
          {
            "if".app-id = "org.videolan.vlc";
            run = "layout floating";
          }
          {
            "if".app-id = "net.kovidgoyal.kitty";
            run = "layout floating";
          }
          {
            "if".app-id = "com.github.wez.wezterm";
            run = "layout floating";
          }
          {
            "if".app-id = "com.apple.Terminal";
            run = "layout floating";
          }
        ];
      };
    };
  };
}
