{ ... }:

{
  programs.nixvim = {
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    extraConfigLuaPre = ''
      --- Move to a window (one of hjkl) or create a split if a window does not exist in the direction.
      --- Lua translation of:
      --- https://www.reddit.com/r/vim/comments/166a3ij/comment/jyivcnl/?utm_source=share&utm_medium=web2x&context=3
      --- Usage: vim.keymap("n", "<C-h>", function() move_or_create_win("h") end, {})
      --
      ---@param key string One of h, j, k, l, a direction to move or create a split
      _G.smarter_win_nav = function(key)
        local fn = vim.fn
        local curr_win = fn.winnr()
        vim.cmd("wincmd " .. key)        --> attempt to move

        if (curr_win == fn.winnr()) then --> didn't move, so create a split
          if key == "h" or key == "l" then
            vim.cmd("wincmd v")
          else
            vim.cmd("wincmd s")
          end

          vim.cmd("wincmd " .. key)      --> move again
        end
      end


      -- Toggle-able floating terminal based on TJ DeVries's video
      local state = {
        floating = {
          buf = -1,
          win = -1,
        }
      }

      local function create_floating_window(opts)
        opts = opts or {}
        local width = opts.width or math.floor(vim.o.columns * 0.8)
        local height = opts.height or math.floor(vim.o.lines * 0.8)
        -- Calculate the position to center the window
        local col = math.floor((vim.o.columns - width) / 2)
        local row = math.floor((vim.o.lines - height) / 2)
        -- Create a buffer
        local buf = nil
        if vim.api.nvim_buf_is_valid(opts.buf) then
          buf = opts.buf
        else
          buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
        end
        -- Create the floating window
        local win_config = {
          relative = "editor",
          width = width,
          height = height,
          col = col,
          row = row,
          style = "minimal",
          border = "rounded",
        }
        local win = vim.api.nvim_open_win(buf, true, win_config)

        return { buf = buf, win = win }
      end

      _G.toggle_terminal = function()
        if not vim.api.nvim_win_is_valid(state.floating.win) then
          state.floating = create_floating_window { buf = state.floating.buf }
          if vim.bo[state.floating.buf].buftype ~= "terminal" then
            vim.cmd.terminal()
          end
        else
          vim.api.nvim_win_hide(state.floating.win)
        end
      end
    '';

    keymaps = [
      {
        mode = [ "n" "v" ];
        key = "<Space>";
        action = "<Nop>";
      }

      # Default overrides
      {
        mode = "n";
        key = "<ESC>";
        action = "<CMD>nohlsearch<CR>";
      }
      {
        mode = "t";
        key = "<ESC><ESC>";
        action = "<C-\\><C-n>";
        options.desc = "Exit terminal mode";
      }
      {
        mode = "n";
        key = "k";
        action = "v:count == 0 ? 'gk' : 'k'";
        options = { expr = true; silent = true; };
      }
      {
        mode = "n";
        key = "j";
        action = "v:count == 0 ? 'gj' : 'j'";
        options = { expr = true; silent = true; };
      }
      { mode = "n"; key = "n"; action = "nzz"; }
      { mode = "n"; key = "N"; action = "Nzz"; }

      # Custom keymaps
      {
        mode = "i";
        key = "jk";
        action = "<ESC>";
        options.desc = "Better ESC";
      }
      {
        mode = "i";
        key = "<C-s>";
        action = "<C-g>u<ESC>[s1z=`]a<C-g>u";
        options.desc = "Fix nearest [S]pelling error and put the cursor back";
      }

      # Emacs alerts
      { mode = "i"; key = "<C-a>"; action = "<C-o>^"; options.desc = "Emacs alert"; }
      { mode = "i"; key = "<C-b>"; action = "<LEFT>"; options.desc = "Sorry"; }
      { mode = "i"; key = "<C-f>"; action = "<RIGHT>"; options.desc = "Hey Emacs users use Evil all the time"; }

      # Copy and paste
      {
        mode = [ "n" "x" ];
        key = "<leader>a";
        action = "gg<S-v>G";
        options.desc = "Select [A]ll";
      }
      {
        mode = "x";
        key = "<leader>y";
        action = "\"+y";
        options.desc = "[Y]ank to the system clipboard (+)";
      }
      {
        mode = "x";
        key = "<leader>p";
        action = "\"_dP";
        options.desc = "[P]aste the current selection without overriding the register";
      }

      # Buffers
      {
        mode = "n";
        key = "[b";
        action = "<CMD>bprevious<CR>";
        options.desc = "Go to previous [B]uffer";
      }
      {
        mode = "n";
        key = "]b";
        action = "<CMD>bnext<CR>";
        options.desc = "Go to next [B]uffer";
      }

      # Terminal
      {
        mode = [ "n" "t" ];
        key = "<leader>tt";
        action.__raw = "_G.toggle_terminal";
        options.desc = "Toggle floating [T]erminal";
      }

      {
        mode = "n";
        key = "<leader>tb";
        action.__raw = ''
          function()
            vim.cmd("botright " .. math.ceil(vim.fn.winheight(0) * 0.3) .. "sp | term")
          end
          '';
        options.desc = "Launch a [T]erminal in the [B]ottom";
      }

      # Smart Window Navigation
      {
        mode = "n";
        key = "<C-h>";
        action = "<CMD>lua _G.smarter_win_nav('h')<CR>";
        options.desc = "Move focus to the left window or create a vertical split";
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<CMD>lua _G.smarter_win_nav('j')<CR>";
        options.desc = "Move focus to the lower window or create a horizontal split";
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<CMD>lua _G.smarter_win_nav('k')<CR>";
        options.desc = "Move focus to the upper window or create a horizontal split";
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<CMD>lua _G.smarter_win_nav('l')<CR>";
        options.desc = "Move focus to the right window or create a vertical split";
      }
    ];
  };
}
