{ pkgs, ... }:

{
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      tabby-nvim
    ];

    extraConfigLua = builtins.readFile ./tabby.lua;
  };
}
