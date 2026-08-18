{
  flake.modules.homeManager.cliphist = {
    services.cliphist = {
      enable = true;
      systemdTargets = [ "niri.service" ];
    };
  };
}
