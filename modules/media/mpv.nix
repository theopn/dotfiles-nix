{
  flake.modules.homeManager.mpv = { pkgs, ... }: {

    programs.mpv = {
      enable = true;

      package = pkgs.mpv.override {
        youtubeSupport = false;
        scripts = [ pkgs.mpvScripts.mpris ];
      };

      config = {
        profile = "gpu-hq";
        hwdec = "auto";

        cursor-autohide = 1000;

        osd-bar = true;

        keep-open = true;
        force-window = true;
      };

      bindings = {
        "l" = "seek 5";
        "h" = "seek -5";
        "j" = "add volume -5";
        "k" = "add volume 5";

        "L" = "seek 60";
        "H" = "seek -60";
        "J" = "add volume -15";
        "K" = "add volume 15";


        "p" = "script-binding osc/visibility";

        "s" = "cycle sub";
      };

    };
  };
}
