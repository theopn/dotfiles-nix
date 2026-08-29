{
  flake.modules.homeManager.fonts = { pkgs, ... }: {
    home.packages = with pkgs; [
      nerd-fonts.fantasque-sans-mono
      nerd-fonts.proggy-clean-tt
    ];

    fonts.fontconfig.enable = true;
  };

  flake.modules.nixos.fonts = { pkgs, ... }: {
    fonts = {
      packages = with pkgs; [
        ubuntu-sans
        ubuntu-sans-mono
        liberation_ttf
        noto-fonts-cjk-sans  # for Korean input
      ];
      fontDir.enable = true;

      fontconfig = {
        enable = true;
        defaultFonts = {
          sansSerif = [ "Ubuntu Sans" ];
          monospace = [ "Ubuntu Sans Mono" ];
          serif     = [ "Liberation Serif" ];
        };
      };
    };

    console = {
      earlySetup = true;
      # 'ter' = terminus
      # 'u' = unicode/latin
      # '32' = size
      # 'n' = normal weight
      font = "ter-u32n";
      packages = [ pkgs.terminus_font ];
    };
  };

}
