{
  flake.modules.homeManager.starship = {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;

      settings = {
        format = "$character$directory([ $git_branch$git_status ](bg:grey fg:black))$python$nix_shell$nodejs ❱ ";
        add_newline = false;
        follow_symlinks = true;
        palette = "nordfox";
        palettes."nordfox" = {
          black   = "#232831";  # bg0
          white   = "#ABB1BB";  # fg2
          grey    = "#7E8188";  # fg3
          cyan    = "#88C0D0";
          green   = "#A3BE8C";
          purple  = "#B48EAD";
          red     = "#BF616A";
          blue    = "#81A1C1";
          yellow  = "#ebcb8b";
        };

        character = {
          success_symbol = "[ I ](bg:blue fg:bold black)";
          error_symbol = "[ I ](bg:red fg:bold black)";
          vimcmd_symbol = "[ N ](bg:green fg:bold black)";
          vimcmd_replace_symbol = "[ R ](bg:purple fg:bold black)";
          vimcmd_replace_one_symbol = "[ R ](bg:purple fg:bold black)";
          vimcmd_visual_symbol = "[ V ](bg:yellow fg:bold black)";
        };
        directory = {
          format = "[ $path$read_only ]($style)";
          style = "bg:black fg:bold white";
          truncation_length = 5;
          truncation_symbol = ".../";
        };
        git_branch = {
          format = "$symbol$branch";
          symbol = "";
        };
        git_status = {
          format = "$all_status";
        };

        python = {
          # ($virtualenv) means conditional
          format = " [ $symbol$version(:$virtualenv) ]($style)";
          style = "bg:blue fg:black";
          symbol = " ";
        };

        nix_shell = {
          format = " [ $symbol$state ]($style)";
          style = "bg:purple fg:black";
          symbol = " ";
        };

        nodejs = {
          format = " [ $symbol$version ]($style)";
          style = "bg:green fg:black";
          symbol = " ";
        };
      };
    };

  };  # flake module ends
}
