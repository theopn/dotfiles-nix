{ ... }:
{
  services.cliphist = {
    enable = true;
    systemdTargets = [ "niri.service" ];
  };
}
