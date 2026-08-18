{
  flake.modules.homeManager.imv = {

    programs.imv = {
      enable = true;
      settings = {
        options = {
          background = "#000000";
          loop_input = true;
          overlay = true;   # d to toggle
          overlay_text_color = "#d8dee9";
          overlay_background_color = "#4c566a";
          recursively = true;  # use :open -r .
          scaling_mode = "shrink";
        };
        binds = {
          n = "next 1";
          p = "prev 1";
        };
      };
    };

  };
}
