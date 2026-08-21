{
  flake.modules.homeManager.xdg-mime = {
    # to get application names:
    # ls -l /run/current-system/sw/share/applications/ /etc/profiles/per-user/${USER}/share/applications/
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
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
  };
}
