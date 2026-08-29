{ ... }:

{
  programs.nixvim = {
    plugins.oil = {
      enable = true;

      settings = {
        delete_to_trash = true;

        view_options = {
          show_hidden = true;
        };
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>n";
        action.__raw = "function() require('oil').open_float(nil, { preview = {} }) end";
        options.desc = "Toggle [N]etrw... <<<< Oil.nvim";
      }
    ];
  };
}
