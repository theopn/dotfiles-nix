{
  flake.modules.homeManager.ripgrep = {
    programs.ripgrep = {
      enable = true;
      arguments = [
        "--hidden"
        "--glob=!.git/"
      ];
    };
  };
}
