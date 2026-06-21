# Linux only config
{ pkgs, lib, config, ... }:

{
  imports = [
    ./config/copyq.nix
    ./config/imv.nix
    ./config/keychain.nix
    ./config/mpv.nix
    ./config/syncthing.nix
    ./config/udiskie.nix
    ./config/zathura.nix

    # Niri
    ./config/dunst.nix
    ./config/gammastep.nix
    ./config/niri.nix
    ./config/rofi.nix
    ./config/swayidle.nix
    ./config/swaylock.nix
    ./config/waybar.nix
  ];

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
}
