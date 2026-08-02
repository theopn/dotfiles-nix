{ config, ... }:
{
  programs.nixvim = {
    plugins.treesitter = {
      enable = true;
      highlight.enable = true;
      indent.enable = true;
      folding.enable = true;

      grammarPackages = with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
          bash fish
          c cpp
          java
          javascript
          lua
          make
          markdown markdown_inline
          nix
          regex
          python
          sql
          vim vimdoc
          json toml xml yaml
      ];
    };
  };
}
