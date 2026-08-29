{
  flake.modules.nixos.xdg-mime = {
    # to get application names:
    # ls -l /run/current-system/sw/share/applications/ /etc/profiles/per-user/${USER}/share/applications/
    xdg.mime.defaultApplications = {
      "application/xhtml+xml"    = [ "librewolf.desktop" "firefox.desktop" ];
      "x-scheme-handler/http"    = [ "librewolf.desktop" "firefox.desktop" ];
      "x-scheme-handler/https"   = [ "librewolf.desktop" "firefox.desktop" ];
      "x-scheme-handler/about"   = [ "librewolf.desktop" "firefox.desktop" ];
      "x-scheme-handler/unknown" = [ "librewolf.desktop" "firefox.desktop" ];

      "x-scheme-handler/mailto"  = "thunderbird.desktop";

      "image/*" = [ "imv-dir.desktop" "gimp.desktop" ];
      "video/*" = "mpv.desktop";
      "audio/*" = "mpv.desktop";

      "application/pdf"      = "org.pwmt.zathura.desktop";
      "application/epub+zip" = "org.pwmt.zathura.desktop";

      "text/*" = "neovide.desktop";
      # NixOS module doesn't seem to have
      # Following line creates duplicate entries in the generated mimeapps.list
      # with Neovide appearing before Firefox no matter what.
      #"text/html" = "firefox.desktop";
      "inode/directory" = "lf.desktop";
    };
  };


  flake.modules.homeManager.xdg-mime = { osConfig, ... }: {
    # some apps like Discord ignores the system level mime
    # but homeManager implementation of mime doesn't seem to have the glob implemented...
    # Issue: https://github.com/nix-community/home-manager/issues/8752
    xdg.configFile."mimeapps.list".source = osConfig.environment.etc."xdg/mimeapps.list".source;
  };

}
