{
  flake.modules.homeManager.cliphist = { pkgs, ... }: {
    services.cliphist = {
      enable = true;
      clipboardPackage = pkgs.wl-clipboard-rs;
      systemdTargets = [ "niri.service" ];
    };
  };
}
