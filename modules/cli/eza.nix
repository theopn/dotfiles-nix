{
  flake.modules.homeManager.eza = {
    programs.eza = {
      enable = true;

      # Do not replace `ls`; I prefer making `l` alias
      enableZshIntegration = false;
      enableFishIntegration = false;

      colors = "auto";
      icons = "auto";  # only output if stdout = terminal
    };
  };
}
