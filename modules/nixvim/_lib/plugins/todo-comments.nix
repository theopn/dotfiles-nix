{ ... }:
{
  programs.nixvim = {
    plugins.todo-comments = {
      enable = true;
      settings = {
        signs = false;
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "]t";
        action.__raw = "function() require('todo-comments').jump_next() end";
        options.desc = "[todo-comments] next TODO";
      }
      {
        mode = "n";
        key = "[t";
        action.__raw = "function() require('todo-comments').jump_prev() end";
        options.desc = "[todo-comments] prev TODO";
      }
    ];
  };
}
