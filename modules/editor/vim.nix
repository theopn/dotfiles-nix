{
  flake.modules.homeManager.vim = {
    programs.vim = {
      enable = true;
      defaultEditor = false;

      extraConfig = builtins.readFile ./vim/.vimrc;
    };
  };
}
