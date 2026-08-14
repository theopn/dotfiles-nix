{ lib, ... }:

{
  services.gammastep = {
    enable = true;
    tray = true;
    temperature = {
      day = 5200;
      night = 4200;
    };
    settings = {
      general = {
        adjustment-method = "wayland";
        gamma-night = 0.9;
        dawn-time = "07:30";
        dusk-time = "21:30";
      };
    };
  };

  systemd.user.services.gammastep = {
    Install.wantedBy = lib.mkForce [ "niri.service" ];
    Unit.BindsTo = [ "niri.service" ];
    Unit.After = [ "niri.service" ];
  };
}
