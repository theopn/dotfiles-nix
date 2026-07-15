{ config, lib, pkgs, ... }:
{
  imports = [
      ./hardware-configuration.nix
      ./idkwhattoname.nix
    ];


  # Boot settings
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;


  # networking & time
  networking.hostName = "wittgenstein";
  networking.networkmanager.enable = true;
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";


  # Hardware services
  services.fwupd.enable = true;
  services.fprintd.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;
  services.blueman.enable = true;
  services.libinput = {
    enable = true;
    touchpad.tapping = true;
    touchpad.naturalScrolling = true;
  };
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  services.printing = {
    enable = true;
    drivers = [ pkgs.cups-filters ];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.udisks2.enable = true;
  # https://knowledgebase.frame.work/optimizing-fedora-battery-life-r1baXZh
  services.tuned.enable = true;
  services.tlp.enable = false;
  services.upower.enable = true;


  # Other services
  services.openssh.enable = true;


  # Actual config is deployed with home-manager
  programs.niri = {
    enable = true;
    useNautilus = true;
  };
  programs.dconf.enable = true;
  # register swaylock to /etc/pam.d/
  security.pam.services.swaylock = {
    # https://www.reddit.com/r/NixOS/comments/16oiazf/swaylock_fprintd_fingerprint_reader_issues/
    text = ''
      # Try password first
      auth sufficient pam_unix.so try_first_pass likeauth nullok nodelay
      # Then fprintd
      auth sufficient pam_fprintd.so
      # Fallback
      auth include login
    '';
  };


  # Me
  programs.zsh.enable = true;
  users.users.theopn = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "input" "dialout" "podman" ];
    shell = pkgs.zsh;
  };


  # Environment variables
  environment.localBinInPath = true;  # add ~/.local/bin to $PATH
  environment.variables = {
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
    LESSHISTFILE = "-";
  };


  # for an emergency
  programs.firefox.enable = true;
  environment.systemPackages = with pkgs; [
    alacritty vim
  ];


  # Nix settings
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11"; # Did you read the comment?
}

