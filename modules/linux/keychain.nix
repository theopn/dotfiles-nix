{
  flake.modules.homeManager.keychain = {

    programs.keychain = {
      enable = true;

      # Since ZSH is my login shell,
      # you do NOT want to have evaluation on the startup,
      # whcih is blocking until you provide the password.
      # I have `keychain_load` alias that does integration on demand.
      # I do not care about Fish being blocked since it is not my login shell
      enableZshIntegration = false;
      enableFishIntegration = true;

      keys = [ "id_ed25519" "id_rsa" ];

      extraFlags = [ "--quick" ];
    };

  };
}
