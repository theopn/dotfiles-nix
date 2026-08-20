{

  # extra things for configuration.nix
  flake.modules.nixos.nixos-base = { pkgs, ... }: {
    fonts.packages = with pkgs; [
      nerd-fonts.proggy-clean-tt
      nerd-fonts.fantasque-sans-mono
      cantarell-fonts
      noto-fonts-cjk-sans  # for Korean input
    ];

    programs.firefox.enable = true;
    programs.thunderbird.enable = true;

    environment.systemPackages = with pkgs; [
      # paying the price for doing the minimal install
      curl wget gcc gdb git killall
      gnumake zip unzip file jq

      # In cases when Niri config breaks
      alacritty vim

      # uhh open source GUI tools
      brave gimp zotero

      # Libreoffice
      libreoffice hunspell hunspellDicts.en_US


      # Propritery
      discord slack spotify zoom-us

      ### -------------------------------- ###
      ### packages that are no longer used ###
      ### -------------------------------- ###

      # CS489 stuff
      #arduino-ide kicad
    ];


    # Environment variables
    environment.localBinInPath = true;  # add ~/.local/bin to $PATH
    environment.variables = {
      EDITOR = "nvim";
      MANPAGER = "nvim +Man!";
      LESSHISTFILE = "-";
    };


    # default applications
    # ls -l /run/current-system/sw/share/applications/ /etc/profiles/per-user/${USER}/share/applications/
    xdg.mime.defaultApplications = {
      "text/html"                = [ "librewolf.desktop" "firefox.desktop" ];
      "application/xhtml+xml"    = [ "librewolf.desktop" "firefox.desktop" ];
      "x-scheme-handler/http"    = [ "librewolf.desktop" "firefox.desktop" ];
      "x-scheme-handler/https"   = [ "librewolf.desktop" "firefox.desktop" ];
      "x-scheme-handler/about"   = [ "librewolf.desktop" "firefox.desktop" ];
      "x-scheme-handler/unknown" = [ "librewolf.desktop" "firefox.desktop" ];
      "x-scheme-handler/mailto"  = [ "librewolf.desktop" "firefox.desktop" ];

      "image/*" = [ "imv-dir.desktop" "gimp.desktop" ];
      "video/*" = "mpv.desktop";
      "audio/*" = "mpv.desktop";

      "application/pdf"      = "org.pwmt.zathura.desktop";
      "application/epub+zip" = "org.pwmt.zathura.desktop";

      "text/*" = "neovide.desktop";
      "inode/directory" = "lf.desktop";
    };

  };
}
