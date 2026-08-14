{ pkgs, ... }:

{
  home.packages = [ pkgs.mate-polkit ];

  systemd.user.services.mate-polkit = {
    Unit = {
      PartOf = [ "niri.service" ];
      After = [ "niri.service" ];
      Requisite = [ "niri.service" ];
    };
    Install = {
      WantedBy = [ "niri.service" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.mate-polkit}/libexec/polkit-mate-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # test that Polkit is running with: `pkexec id` (prompts terminal PW if no Polkit is running)
}
