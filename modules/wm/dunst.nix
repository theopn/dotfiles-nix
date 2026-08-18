{
  flake.modules.homeManager.dunst = { pkgs, ... }: {
    services.dunst = {
      enable = true;

      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
        size = "32x32";
      };

      settings = {
        global = {
          follow = "mouse";
          frame_width = 3;
          frame_color = "#88c0d0";  # nord8
          separator_color = "frame";
          highlight = "#88c0d0";    # nord8

          font = "ProggyClean Nerd Font 16";
          corner_radius = 10;
          origin = "top-center";
          offset = "(0, 10)";

          enable_recursive_icon_lookup = true;

          indicate_hidden = true;
          alignment = "left";
          sticky_history = true;
          history_length = 20;
        };

        urgency_low = {
          background = "#3b4252";  # nord1
          foreground = "#e5e9f0";  # nord5
          timeout = 5;
        };

        urgency_normal = {
          background = "#3b4252";  # nord1
          foreground = "#e5e9f0";  # nord5
          timeout = 15;
        };

        urgency_critical = {
          background = "#3b4252";  # nord1
          foreground = "#e5e9f0";  # nord5
          frame_color = "#d08770"; # nord12
          timeout = 0;
        };

        volume-ignore = {
          summary = "*Volume:*";
          history_ignore = true;
        };

        brightness-ignore = {
          summary = "*Brightness:*";
          history_ignore = true;
        };
      };
    };

  };  # flake module ends
}
