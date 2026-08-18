{
  flake.modules.darwin.homebrew = { ... }:
    let
      externalAppDir = "/Volumes/theo-crucial-p310/Applications";
    in
    {
      homebrew = {
        enable = true;
        casks = [
          # Dev
          "docker-desktop"
          #{
          # name = "docker-desktop";
          # args = { appdir = externalAppDir };
          #}
          #"kicad"

          # Fun & Media
          "gimp"
          #{
          # name = "gimp";
          # args = { appdir = externalAppDir };
          #}
          #"minecraft"
          "obs"
          #{
          # name = "obs";
          # args = { appdir = externalAppDir };
          #}
          "spotify"

          # Productivity
          "itsycal"
          "notion"
          "zotero"
          #{
          # name = "zotero";
          # args = { appdir = externalAppDir };
          #}

          # Sync
          "filen"
          #{
          # name = "filen";
          # args = { appdir = externalAppDir };
          #}
          "syncthing-app"

          # System
          "jordanbaird-ice"
          "stats"

          # Tools
          "keycastr"
          #{
          # name = "keycastr";
          # args = { appdir = externalAppDir };
          #}
          "skim"

          # Web
          "brave-browser"
          #{
          # name = "brave-browser";
          # args = { appdir = externalAppDir };
          #}
          "discord"
          "firefox"
          "tailscale-app"
          "thunderbird"
        ];

        # Delete unspecified Homebrew formulae
        onActivation = {
          autoUpdate = true;
          upgrade = true;
          cleanup = "zap";
        };
      };
    };
}
