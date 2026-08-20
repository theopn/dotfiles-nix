{
  flake.modules.homeManager.home-base = { pkgs, lib, config, ... }: {
    xdg.enable = true;

    home.sessionVariables = {
      XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures";
      XDG_PICTURES_DIR = "${config.home.homeDirectory}/Pictures";

      THEOSHELL_TRASH_DIR = "${config.xdg.dataHome}/theoshell/trash";
    };

    home.packages = with pkgs; [
      # tools
      hugo
      openconnect
      qemu
      #tmux
      tree
      wget

      # media
      exiftool
      ffmpeg
      figlet
      imagemagick
      pandoc

      # dev
      nodejs_24
      python3
      #r
      cargo
      rustc
      sqlite

      # Horrible name, but platformio = platformio-chrootenv = FHS wrapper for Linux
      # Configuring udev rule doesn't seem to be necessary as long as `dialout` group is set
      # https://docs.platformio.org/en/stable//core/installation/udev-rules.html
      # I am not sure if I will ever use this again after CS489
      #(if stdenv.isLinux then platformio else platformio-core)
    ];

    programs.man.generateCaches = lib.mkIf pkgs.stdenv.isDarwin false;
    programs.home-manager.enable = true;

    home.stateVersion = "26.05";
  };
}
