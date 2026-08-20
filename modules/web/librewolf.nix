{
  flake.modules.homeManager.librewolf = {
    programs.librewolf = {
      enable = true;
      # https://librewolf.net/docs/settings/#where-do-i-find-my-librewolfoverridescfg
      # https://codeberg.org/librewolf/settings/src/branch/master/librewolf.cfg
      # and about:config
      settings = {
        # webgl
        "webgl.disabled" = false;
        # firefox sync
        "identity.fxaccounts.enabled" = true;

        # nothing in the bottom of sidebar
        "sidebar.revamp" = true;
        "sidebar.verticalTabs" = true;
        "sidebar.main.tools" = "";

        "browser.tabs.inTitlebar" = 1;

        # yeahhh i am not cut for some privacy features
        "privacy.clearOnShutdown.cookies" = false;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearHistory.cookiesAndStorage" = false;
        "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
        "privacy.clearSiteData.cookiesAndStorage" = false;
        "privacy.resistFingerprinting.letterboxing" = false;

        "browser.startup.page" = 1;
        "browser.startup.homepage" = "https://theopark.me/startpage";
        "browser.newtabpage.enabled" = false;
      };

      policies = {
        # about:support to get ID
        ExtensionSettings = {
          # Bitwarden
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
            installation_mode = "force_installed";
          };
          # Vimium
          "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
            installation_mode = "force_installed";
          };
          # Raindrop.io
          "jid0-adyhmvsP91nUO8pRv0Mn2VKeB84@jetpack" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/raindropio/latest.xpi";
            installation_mode = "force_installed";
          };
          # Unhook
          "myallychou@gmail.com" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/youtube-recommended-videos/latest.xpi";
            installation_mode = "force_installed";
          };
          # Nord
          "{f4c9e1d6-6630-4600-ad50-d223eab7f3e7}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/nord-firefox/latest.xpi";
            installation_mode = "force_installed";
          };
          # Tokyonight
          "{4520dc08-80f4-4b2e-982a-c17af42e5e4d}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/tokyo-night-milav/latest.xpi";
            installation_mode = "force_installed";
          };
        };
      };
    };

  };
}
