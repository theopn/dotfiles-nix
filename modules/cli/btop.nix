{
  flake.modules.homeManager.btop = {
    programs.btop = {
      enable = true;
      settings.color_theme = "TTY";
    };
  };
}
