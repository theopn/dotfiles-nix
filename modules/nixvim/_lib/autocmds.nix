{ ... }:

{
  programs.nixvim = {
    autoCmd = [
      {
        event = [ "TextYankPost" ];
        pattern = "*";
        callback.__raw = "function() vim.hl.on_yank({ timeout = 300, }) end";
      }

      {
        event = [ "TermOpen" "BufEnter" ];
        pattern = [ "term://*" ];
        callback.__raw = "function() vim.cmd('startinsert') end";
      }

      # spellings
      {
        event = [ "FileType" ];
        pattern = [ "org" "tex" "text" ];
        command = "setlocal spell";
      }
      {
        event = [ "FileType" ];
        pattern = [ "markdown" ];
        command = "setlocal expandtab tabstop=4 softtabstop=4 shiftwidth=4 spell";
      }
      # tab character ew
      {
        event = [ "FileType" ];
        pattern = [ "gitconfig" "make" ];
        command = "setlocal noexpandtab softtabstop=0 shiftwidth=0";
      }
      {
        event = [ "FileType" ];
        pattern = [ "c" "cpp" ];
        callback.__raw = ''
          function()
            vim.cmd([[
              setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2
              setlocal colorcolumn=80 textwidth=79
              setlocal matchpairs+==:;
              command! -buffer RunC !gcc "%:p" -Wall -Werror -std=c17 -o "%:p:r" && "%:p:r"
              command! -buffer RunCpp !g++ "%:p" -Wall -Werror -std=c++11 -o "%:p:r" && "%:p:r"
            ]])
          end
        '';
      }
      {
        event = [ "FileType" ];
        pattern = [ "python" ];
        callback.__raw = ''
          function()
            vim.cmd([[
              setlocal expandtab tabstop=4 softtabstop=4 shiftwidth=4
              setlocal colorcolumn=80 textwidth=79
              command! -buffer RunPython !python3 "%:p"
            ]])
          end
        '';
      }
      {
        event = [ "FileType" ];
        pattern = [ "lua" ];
        callback.__raw = ''
          function()
            vim.cmd([[
              setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2
              setlocal colorcolumn=120 textwidth=119
              command! -buffer RunLua !lua "%:p"
            ]])
          end
        '';
      }
      {
        event = [ "FileType" ];
        pattern = [ "java" ];
        callback.__raw = ''
          function()
            vim.cmd([[
              setlocal expandtab tabstop=4 softtabstop=4 shiftwidth=4
              setlocal colorcolumn=120 textwidth=119
              setlocal matchpairs+==:;
            ]])
          end
        '';
      }

    ];
  };
}
