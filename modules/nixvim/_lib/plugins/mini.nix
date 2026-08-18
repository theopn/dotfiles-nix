{ ... }:

{
  programs.nixvim = {
    plugins.mini = {
      enable = true;

      modules = {

        pairs = {};

        indentscope = {};

        statusline = {
          use_icons = true;
          set_vim_settings = true;
        };

        starter = {
          # figlet -f small theovim
          header = ''
                     \/   \/
                     |\__/,|     _
                   _.|o o  |_   ) )
                  -(((---(((--------
                      [ Oliver ]
             _   _                _
            | |_| |_  ___ _____ _(_)_ __
            |  _| ' \/ -_) _ \ V / | '  \
             \__|_||_\___\___/\_/|_|_|_|_|
            '';
        };

        clue = {
          triggers = [
            # leader
            { mode = "n"; keys = "<Leader>"; }
            { mode = "x"; keys = "<Leader>"; }
            # square brackets
            { mode = "n"; keys = "]"; }
            { mode = "n"; keys = "["; }
            # builtin completion
            { mode = "i"; keys = "<C-x>"; }
            # g
            { mode = "n"; keys = "g"; }
            { mode = "x"; keys = "g"; }
            # marks
            { mode = "n"; keys = "'"; }
            { mode = "x"; keys = "'"; }
            { mode = "n"; keys = "`"; }
            { mode = "x"; keys = "`"; }
            # registers
            { mode = "n"; keys = "\""; }
            { mode = "x"; keys = "\""; }
            { mode = "i"; keys = "<C-r>"; }
            # window commands
            { mode = "n"; keys = "<C-w>"; }
            # z
            { mode = "n"; keys = "z"; }
            { mode = "x"; keys = "z"; }
          ];

          clues = [
            { __raw = "require('mini.clue').gen_clues.square_brackets()"; }
            { __raw = "require('mini.clue').gen_clues.builtin_completion()"; }
            { __raw = "require('mini.clue').gen_clues.g()"; }
            { __raw = "require('mini.clue').gen_clues.marks()"; }
            { __raw = "require('mini.clue').gen_clues.registers()"; }
            { __raw = "require('mini.clue').gen_clues.windows()"; }
            { __raw = "require('mini.clue').gen_clues.z()"; }
          ];

          window = {
            delay = 300;
            config = {
              width = "auto";
              border = "rounded";
            };
          };
        };

      };
    };
  };
}
