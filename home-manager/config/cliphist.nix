{ pkgs, ... }:
# nixpkgs includes cliphist-rofi-img script from:
# https://github.com/sentriz/cliphist/blob/master/contrib/cliphist-rofi-img
{
  services.cliphist = {
    enable = true;
    systemdTarget = "niri.service";
  };
}
