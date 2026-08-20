{
  flake.modules.homeManager.zoxide = {
    programs.zoxide = {
      enable = true;

      enableZshIntegration = true;
      enableFishIntegration = true;

      options = [ "--cmd c" ];
    };
  };
}
