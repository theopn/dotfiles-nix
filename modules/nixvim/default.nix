{ inputs, ... }:
{
  flake.modules.homeManager.nixvim = {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;

      extraConfigLua = builtins.readFile ./_lib/neovide.lua;
    };

    imports = [
      inputs.nixvim.homeModules.nixvim

      # defaults
      ./_lib/opts.nix
      ./_lib/autocmds.nix
      ./_lib/usercommands.nix
      ./_lib/keymaps.nix

      ./_lib/plugins/mini.nix

      # UI
      ./_lib/plugins/colorschemes.nix
      ./_lib/plugins/web-devicons.nix
      ./_lib/plugins/tabby.nix
      ./_lib/plugins/colorizer.nix
      ./_lib/plugins/todo-comments.nix

      # editing
      ./_lib/plugins/lsp.nix
      ./_lib/plugins/blink-cmp.nix
      ./_lib/plugins/fidget.nix
      ./_lib/plugins/treesitter.nix
      ./_lib/plugins/gitsigns.nix
      ./_lib/plugins/yanky.nix

      # files
      ./_lib/plugins/fzf-lua.nix
      ./_lib/plugins/oil.nix

      # language-specific
      ./_lib/plugins/orgmode.nix
      ./_lib/plugins/render-markdown.nix
      ./_lib/plugins/vimtex.nix
    ];
  };
}
