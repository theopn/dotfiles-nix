{
  flake.modules.nixos.dconf = {
    programs.dconf.enable = true;
  };

  flake.modules.homeManager.dconf = {
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        cursor-theme = "Adwaita";
        cursor-size = 24;
        font-name = "Cantarell 12";
        document-font-name = "Cantarell 12";
        font-antialiasing = "rgba";
        font-hinting = "slight";
      };
    };

  };
}
