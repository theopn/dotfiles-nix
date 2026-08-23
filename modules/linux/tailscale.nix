{
  flake.modules.nixos.tailscale = { config, ... }: {
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

  };
}
