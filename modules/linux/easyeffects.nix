{
  flake.modules.homeManager.easyeffects = { pkgs, ... }:
  let
    irs = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/FrameworkComputer/linux-docs/main/easy-effects/irs/IR_22ms_27dB_5t_15s_0c.irs";
      # https://github.com/FrameworkComputer/linux-docs/commit/f2d52e46b456b34717fc574bf18987ea525c59e3
      hash = "sha256-IxDXNhnTg/NrhPxA5+6u/meEnlX720eoQPyoJfbuge0=";
    };

    # fw13-preset = pkgs.fetchurl {
    #   url = "https://raw.githubusercontent.com/FrameworkComputer/linux-docs/main/easy-effects/fw13-easy-effects.json";
    #   # https://github.com/FrameworkComputer/linux-docs/commit/e5289ecc283e0e940536ce48e0ed789adf0280be
    #   hash = "sha256-SNSUu858z6+RdcRH9xgBTJeSDJmLu2RINx+OUaWGH3A=";
    # };

    fw16-preset = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/FrameworkComputer/linux-docs/main/easy-effects/fw16-easy-effects.json";
      # https://github.com/FrameworkComputer/linux-docs/commit/46ca475967323505d700760f78c7a3202840ef61
      hash = "sha256-Te8S9DsG5P/NuNk5WE6mSB/DjHS+rKjOFRN7mDEVg8g=";
    };
  in
  {
    xdg.configFile = {
      "easyeffects/irs/IR_22ms_27dB_5t_15s_0c.irs".source = irs;
      #"easyeffects/output/fw13-easy-effects.json".source = fw13-preset;
      "easyeffects/output/fw16-easy-effects.json".source = fw16-preset;
    };

    services.easyeffects = {
      enable = true;
      # I like the bassy sound of "FW16 preset" better (they are just EQ settings)
      preset = "fw16-easy-effects";
    };

  };  # flake module ends
}
