{
  flake.modules.homeManager.fzf = {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      defaultCommand = "fd --hidden --strip-cwd-prefix --exclude '.git'";
      defaultOptions = [
        "--layout=reverse"
        "--cycle"
        "--height=50%"
        "--margin=5%"
        "--border=double"
      ];
    };
  };
}
