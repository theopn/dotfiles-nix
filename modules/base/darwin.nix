{
  # packages, variables, and fallthrough nix-darwin settings
  flake.modules.darwin.darwin-base = {

    environment.variables = {
      EDITOR = "nvim";
      MANPAGER = "nvim +Man!";
      LESSHISTFILE = "-";
    };

  };
}
