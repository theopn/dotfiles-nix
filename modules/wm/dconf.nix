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
        font-name = "Ubuntu Sans 12";
        document-font-name = "Ubuntu Sans 12";
        monospace-font-name = "Ubuntu Sans Mono 12";
        font-antialiasing = "rgba";
        font-hinting = "slight";
      };
    };

  };
}
