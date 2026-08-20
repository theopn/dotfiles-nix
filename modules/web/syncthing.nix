{
  flake.modules.homeManager.syncthing = {
    services.syncthing = {
      enable = true;
      overrideDevices = false;
      overrideFolders = false;
    };
  };
}
