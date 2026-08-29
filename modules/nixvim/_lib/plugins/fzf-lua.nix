{ ... }:

{
  programs.nixvim = {
    plugins.fzf-lua = {
      enable = true;

      settings = {
        keymap = {
          builtin = {
            "<C-b>" = "preview-page-down";
            "<C-f>" = "preview-page-up";
          };
        };

        grep = {
          rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --hidden -e";
          actions = {
            "ctrl-a" = {
              fn = {
                __raw = ''
                  function(_, opts)
                    local fzf = require("fzf-lua")
                    fzf.actions.toggle_flag(
                      _,
                      vim.tbl_extend("force", opts, {
                        toggle_flag = "--smart-case",
                      })
                    )
                  end
                '';
              };
              desc = "toggle-flags";
              header = {
                __raw = ''
                  function(o)
                    local fzf = require("fzf-lua")
                    local flag = o.toggle_smart_case_flag or "--smart-case"
                    if o.cmd and o.cmd:match(fzf.utils.lua_regex_escape(flag)) then
                      return "Disable smart case"
                    else
                      return "Enable smart case"
                    end
                  end
                '';
              };
            };
          };
        };
      };  # fzf-lua

      keymaps = {
        "<leader><leader>" = { action = "buffers"; options.desc = "[ ] Search buffers"; };
        "<leader>." = { action = "oldfiles"; options.desc = "[.] Search oldfiles (dot repeat)"; };
        "<leader>sf" = { action = "files"; options.desc = "[S]earch [F]iles"; };

        "<leader>/" = { action = "blines"; options.desc = "[/] Search words in the buffer"; };
        "<leader>sg" = { action = "live_grep"; options.desc = "[S]earch by Live rip[G]rep (current directory)"; };

        "<leader>sj" = { action = "jumps"; options.desc = "[S]earch [J]umplist"; };
        "<leader>st" = { action = "tabs"; options.desc = "[S]earch [T]abs"; };

        "<leader>sh" = { action = "command_history"; options.desc = "[S]earch Command [H]istory"; };
        "<leader>sc" = { action = "colorschemes"; options.desc = "[S]earch [C]olorschemes"; };
        "<leader>ss" = { action = "builtin"; options.desc = "[S]earch [S]earch (builtin)"; };
        "<leader>sr" = { action = "resume"; options.desc = "[S]earch [R]esume"; };

        "<leader>gc" = { action = "git_commits"; options.desc = "Search [G]it [C]ommits"; };
        "<leader>gs" = { action = "git_status"; options.desc = "Search [G]it [S]tatus"; };
      };
    };

    extraConfigLua = ''
      require("fzf-lua").register_ui_select()
      '';

    keymaps = [
      # prompt list of paraent directories -> launch fzf.files in the selected dir
      {
        mode = "n";
        key = "<leader>d-";
        action = {
          __raw = ''
            function()
              local fzf = require("fzf-lua")
              local dirs = {}
              for dir in vim.fs.parents(vim.uv.cwd()) do
                dirs[#dirs + 1] = dir
              end

              fzf.fzf_exec(dirs, {
                prompt = "Parent Directories❯ ",
                actions = {
                  ["default"] = function(selected)
                    fzf.files({ cwd = selected[1] })
                  end
                }
              })
            end
          '';
        };
        options.desc = "Select & Search Parent([-]) [D]irectories";
      }
    ];
  };

}
