{
  flake.modules.homeManager.git = { pkgs, ... }: {

    home.packages = with pkgs; [
      git-filter-repo
    ];

    programs.git = {
      enable = true;

      settings = {
        user = {
          name  = "Theo Park";
          email = "theo.park.n@gmail.com";
        };
        core ={
          editor = "nvim";
          pager = "nvim -R +'set nomodifiable noswapfile nocursorcolumn nonumber norelativenumber scrolloff=999' +'set ft=git' -";
          autocrlf = "input";
        };
        # Disable color escape code since I use neovim as a pager
        color.pager = false;
        # delete outdated branches during fetch
        fetch.prune = true;
        init.defaultBranch = "main";
        status.short = true;
        https.postbuffer = 157286400;
        submodule.recurse = true;
        push.recurseSubmodules = "on-demand";
      };

      ignores =[
        ".DS_Store"
        ".idea/"
        "*.xml"
        "*.iml"
        "*.class"
        "./auto/*"
        "*~"
        "npm-debug.log"
        "*.aux"
        "*.lof"
        "*.log"
        "*.lot"
        "*.fls"
        "*.out"
        "*.toc"
        "*.fmt"
        "*.fot"
        "*.cb"
        "*.cb2"
        ".*.lb"
        "*fdb_latexmk"
        "*.synctex.gz"
        "latex.out/"
        "_minted/"
        "*.bbl"
        "*.bcf"
        "*.blg"
        "*-blx.aux"
        "*-blx.bib"
        "*.run.xml"
      ];
    };

  };  # flake module ends
}
