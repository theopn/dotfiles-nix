{
  flake.modules.homeManager.neovide = { pkgs, ... }: {
    programs.neovide= {
      enable = true;
      settings = {
        frame = if pkgs.stdenv.isDarwin then "transparent" else "full";
        title-hidden = true;
        font = {
          normal = [ "FantasqueSansM Nerd Font" "ProggyClean Nerd Font" "ComicCodeLigatures Nerd Font" ];
          size = 16.0;
        };
      };
    };

  };
}
