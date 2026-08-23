{ ... }:

{
  programs.nixvim = {
    plugins.gitsigns = {
      enable = true;

      settings = {
        signs = {
          add = { text = "+"; };
          change = { text = "~"; };
          delete = { text = "_"; };
          topdelete = { text = "‾"; };
          changedelete = { text = "~"; };
        };

        on_attach = {
          __raw = ''
            function(bufnr)
              local gitsigns = require("gitsigns")

              local function map(mode, l, r, opts)
                opts = opts or { desc = "" }
                opts.buffer = bufnr
                opts.desc = "[Gitsigns] " .. opts.desc
                vim.keymap.set(mode, l, r, opts)
              end

              map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "[H]unk [s]tage the hunk under the cursor" })
              map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "[H]unk [R]eset the hunk under the cursor" })

              map("v", "<leader>hs", function()
                gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
              end, { desc = "[H]unk [S]tage the selection" })
              
              map("v", "<leader>hr", function()
                gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
              end, { desc = "[H]unk [R]eset the selection" })

              map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "[H]unk [S]tage current buffer" })

              map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "[H]unk [P]review" })

              map("n", "<leader>hb", function()
                gitsigns.blame_line({ full = true })
              end, { desc = "[H]unk [B]lame the hunk under the cursor" })

              map("n", "<leader>hd", gitsigns.diffthis, { desc = "[H]unk [D]iff current buffer" })
            end
          '';
        };
      };
    };
  };
}
