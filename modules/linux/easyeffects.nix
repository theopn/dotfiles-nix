{
  flake.modules.homeManager.easyeffects = { pkgs, ... }:
  let
    fw16-preset = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/FrameworkComputer/linux-docs/main/easy-effects/fw16-easy-effects.json";
      # https://github.com/FrameworkComputer/linux-docs/commit/46ca475967323505d700760f78c7a3202840ef61
      hash = "sha256-Te8S9DsG5P/NuNk5WE6mSB/DjHS+rKjOFRN7mDEVg8g=";
    };
  in
  {
    xdg.configFile = {
      "easyeffects/output/fw16-easy-effects.json".source = fw16-preset;
    };

    services.easyeffects = {
      enable = true;
      # I like the bassy sound of "FW16 preset" better (they are just EQ settings)
      preset = "fw16-easy-effects";
    };

  };  # flake module ends
}
