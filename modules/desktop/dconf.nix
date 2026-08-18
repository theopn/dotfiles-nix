{
  flake.modules.nixos.dconf = {
    programs.dconf.enable = true;
  };

  flake.modules.homeManager.theme = { pkgs, ... }: {
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

    gtk = {
      enable = true;
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
      cursorTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
        size = 24;
      };
      font = {
        name = "Cantarell";
        package = pkgs.cantarell-fonts;
        size = 12;
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk3";
      style.name = "adwaita-dark";
    };

  };
}
