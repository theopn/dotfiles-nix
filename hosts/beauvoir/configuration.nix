{ pkgs, inputs, ... }:

let
  saymyname = "theopn";  # you are goddamn right
in
{
  environment.variables = {
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
    LESSHISTFILE = "-";
  };

  # enable Fish in system level.
  # ensures $PATH is set correctly,
  # even when you launch app through Spotlight.
  programs.fish.enable = true;
  users.users.${saymyname} = {
    name = saymyname;
    home = "/Users/${saymyname}";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.proggy-clean-tt
    nerd-fonts.fantasque-sans-mono
  ];

  system.primaryUser = saymyname;
  system.defaults = {
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;

      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;

      InitialKeyRepeat = 20;
      KeyRepeat = 2;
    };

    spaces.spans-displays = true; # recommended to make Aerospace behave like i3

    dock = {
      mru-spaces = false;         # required for Aerospace

      autohide = true;
      autohide-delay = 0.1;          # how long to hold the mouse
      autohide-time-modifier = 0.3;  # animation speed
      orientation = "left";
      persistent-apps = [
        {
          spacer = {
            small = true;
          };
        }
      ];
      persistent-others = [
          { folder = "/Users/${saymyname}/Downloads"; }
      ];
      showhidden = true;
    };

    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      NewWindowTarget = "Home";
      ShowPathbar = true;
      ShowStatusBar = true;
      _FXShowPosixPathInTitle = true;
      _FXSortFoldersFirst = true;
    };

    screencapture = {
      type = "jpg";
      location = "/Users/${saymyname}/Downloads";
    };

    CustomUserPreferences = {
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
    };
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  # Let Determinate Nix win
  nix.enable = false;

  nix.settings.experimental-features = "nix-command flakes";
  system.stateVersion = 6;
}
