{
  flake.modules.homeManager.portal = { pkgs, ... }: {
    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
      ];
      config.common.default = [ "gnome" "gtk" ];
    };

    services.gnome-keyring = {
      enable = true;
      # SSH keys are managed with `keychain` so no need for that
      components = [ "secrets" ];
    };
  };
}
