{ lib, flake-parts-lib, ... }:
{
  options.flake = flake-parts-lib.mkSubmoduleOptions {
    modules = lib.mkOption {

      type = lib.types.lazyAttrsOf (lib.types.lazyAttrsOf lib.types.deferredModule);

      default = { };

      description = ''
        Theo's custom Dendritic pattern registry: flake.modules.<class>.<name>.
        Each <class> (nixos, homeManager, darwin, ...) holds named modules
        that hosts can import.
      '';
    };
  };
}
