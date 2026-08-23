{
  flake.modules.homeManager.cliphist = {
    services.cliphist = {
      enable = true;
      # --watch command is not implemented, which breaks the entire purpose of it
      #clipboardPackage = pkgs.wl-clipboard-rs;
      systemdTargets = [ "niri.service" ];
    };
  };
}
