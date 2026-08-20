{
  flake.modules.nixos.printing = { pkgs, ... }: {
    services.printing = {
      enable = true;
      drivers = [ pkgs.cups-filters ];
    };
  };
}
