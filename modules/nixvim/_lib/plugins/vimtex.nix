{ pkgs, ... }:

let
  myTexlive = pkgs.texliveSmall.withPackages (ps: with ps; [
    # compilation
    latexmk luatex synctex

    amsmath amstex amsfonts
    enumitem minted soul hyperref framed
    tcolorbox ps.import xcolor
    geometry titlesec

    forest

    algorithms
    # algpseudocodex dependencies
    algpseudocodex algorithmicx fifo-stack varwidth
    kvoptions etoolbox tabto-ltx totcount tikzmark

    # font related
    sourcesanspro sourcecodepro sourceserifpro ly1
    fontawesome
  ]);
in
{

  # expose latexmk to the system as well
  home.packages = [ myTexlive ];

  programs.nixvim = {
    plugins.vimtex = {
      texlivePackage = myTexlive;
      zathuraPackage = pkgs.zathura;

      enable = true;

      settings = {
        view_method = if pkgs.stdenv.isDarwin then "skim" else "zathura";

        compiler_method = "latexmk";
        tex_flavor = "latex";

        # Apparently not needed in NixOS
        # --shell-escape allows use of external tools
        # e.g., minted requiring pygmentize
        # compiler_latexmk = {
        #   options = [
        #     "-shell-escape"
        #     "-verbose"
        #     "-file-line-error"
        #     "-synctex=1"
        #     "-interaction=nonstopmode"
        #   ];
        # };
      };

    };
  };
}
