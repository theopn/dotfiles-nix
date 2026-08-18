{
  flake.modules.homeManager.fastfetch = {

    programs.fastfetch = {
      enable = true;
      settings = {
        logo = {
          type= "small";
        };
        modules = [
          "separator"
          {
            "type" = "title";
            "format" = "{host-name-colored}";
          }
          "separator"

          "os"
          "packages"
          "wm"

          "host"

          "terminal"
          "shell"
          "terminalfont"

          "break"
          "colors"
          "break"
        ];
      };
    };

  };
}
