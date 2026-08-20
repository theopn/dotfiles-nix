{
  flake.modules.nixos.udisks2 = {
    services.udisks2.enable = true;
  };

  flake.modules.homeManager.udiskie = {
    services.udiskie = {
      enable = true;
      automount = false;
      notify = true;
      tray = "auto";
    };
  };
}
