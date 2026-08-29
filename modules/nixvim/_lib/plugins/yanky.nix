{ ... }:

{
  programs.nixvim = {
    plugins.yanky = {
      enable = true;

      settings = {
        ring = {
          history_length = 20;
        };
        highlight = {
          on_put = true;
          on_yank = false;  # I have an autocmd for that already
          timer = 300;
        };
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>p";
        action = "<cmd>YankyRingHistory<cr>";
        options.desc = "Open Yank History";
      }
      {
        mode = [ "n" "x" ];
        key = "p";
        action = "<Plug>(YankyPutAfter)";
        options.desc = "Put yanked text after cursor";
      }
      {
        mode = [ "n" "x" ];
        key = "P";
        action = "<Plug>(YankyPutBefore)";
        options.desc = "Put yanked text before cursor";
      }
      {
        mode = [ "n" "x" ];
        key = "gp";
        action = "<Plug>(YankyGPutAfter)";
        options.desc = "Put yanked text after selection";
      }
      {
        mode = [ "n" "x" ];
        key = "gP";
        action = "<Plug>(YankyGPutBefore)";
        options.desc = "Put yanked text before selection";
      }
      {
        mode = "n";
        key = "<c-p>";
        action = "<Plug>(YankyPreviousEntry)";
        options.desc = "Select previous entry through yank history";
      }
      {
        mode = "n";
        key = "<c-n>";
        action = "<Plug>(YankyNextEntry)";
        options.desc = "Select next entry through yank history";
      }
    ];
  };
}
