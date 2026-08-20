{
  # packages, variables, and fallthrough nix-darwin settings
  flake.modules.darwin.darwin-base = { pkgs, ... }: {
    fonts.packages = with pkgs; [
      nerd-fonts.proggy-clean-tt
      nerd-fonts.fantasque-sans-mono
    ];

    environment.variables = {
      EDITOR = "nvim";
      MANPAGER = "nvim +Man!";
      LESSHISTFILE = "-";
    };

  };
}
