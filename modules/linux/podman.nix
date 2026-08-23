{
  flake.modules.nixos.podman = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      podman-compose podman-tui
    ];

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
