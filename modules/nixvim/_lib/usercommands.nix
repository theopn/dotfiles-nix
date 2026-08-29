{ ... }:

{
  programs.nixvim = {
    userCommands = {
      TrimWhitespace = {
        command = {
          __raw = ''
            function()
              local win_save = vim.fn.winsaveview()
              vim.cmd([[keeppatterns %s/\s\+$//ec]])
              vim.fn.winrestview(win_save)
            end
          '';
        };
        desc = "Trims trailing whitespace (with confirmations)";
      };

      CD = {
        # NixVim automatically handles the `:` execution for strings
        command = "lcd %:h";
        desc = "Changes local PWD to the curr file's directory";
      };

      RO = {
        command = "setlocal readonly nomodifiable";
        desc = "Sets the buffer to readonly + nomodifiable";
      };
    };
  };
}
