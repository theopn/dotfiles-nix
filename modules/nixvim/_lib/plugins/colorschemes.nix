{ ... }:

{
  programs.nixvim = {
    colorscheme = "nordfox";

    colorschemes = {
      nightfox = {
        enable = true;
      };

      tokyonight = {
        enable = true;
        settings.style = "night";
      };

      kanagawa.enable = true;
      onedark.enable = true;
    };
  };
}
