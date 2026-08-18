{

  # things that would be located in `configuration.nix`
  flake.modules.nixos.linux-base = { config, pkgs, ... }: {
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

      # Podman
      podman-compose podman-tui

      # Propritery
      discord slack spotify zoom-us

      ### -------------------------------- ###
      ### packages that are no longer used ###
      ### -------------------------------- ###

      # CS489 stuff
      #arduino-ide kicad
    ];

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

    # fcitx5
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        ignoreUserConfig = true;
        addons = with pkgs; [ fcitx5-hangul ];
        settings = {
          inputMethod = {
            GroupOrder."0" = "Default";
            "Groups/0" = {
              Name = "Default";
              "Default Layout" = "us";
              DefaultIM = "keyboard-us";
            };
            "Groups/0/Items/0".Name = "keyboard-us";
            "Groups/0/Items/1".Name = "hangul";
          };
        };
      };
    };

    # https://wiki.nixos.org/wiki/Tailscale
    services.tailscale.enable = true;
    networking.nftables.enable = true;
    networking.firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };
    systemd.services.tailscaled.serviceConfig.Environment = [
      "TS_DEBUG_FIREWALL_MODE=nftables"
    ];

    # Podman
    virtualisation = {
      containers.enable = true;
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };
  };
}
