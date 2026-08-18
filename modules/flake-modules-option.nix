{ lib, flake-parts-lib, ... }:
{
  options.flake = flake-parts-lib.mkSubmoduleOptions {
    modules = lib.mkOption {
      type = lib.types.lazyAttrsOf (lib.types.lazyAttrsOf lib.types.deferredModule);
      default = { };
      description = ''
        Dendritic-pattern aspect registry: flake.modules.<class>.<name>.
        Each <class> (nixos, homeManager, darwin, ...) holds named,
        composable modules that hosts import by name.
      '';
    };
  };
}
