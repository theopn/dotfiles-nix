{ ... }:

{
  programs.nixvim = {
    plugins.fidget = {
      enable = true;
      settings = {
        notification = {
          window = {
            border = "rounded";
            align = "top";
          };
        };
      };
    };
  };
}
