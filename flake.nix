{
  description = "Theo's Nix Flake for NixOS (Framework 13), nix-darwin (M4 Mac Mini), and home-manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim.url = "github:nix-community/nixvim";

    # For the Dendritic pattern
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
  };

  outputs = inputs@{ self, nixpkgs, nixos-hardware, nix-darwin, home-manager, ... }:
    let
      # scanned modules from import-tree
      dendriticModules = inputs.flake-parts.lib.mkFlake { inherit inputs; } (
        inputs.import-tree ./modules
      );

      # function that populates a common home-manager config
      mkHomeManager = { saymyname, theosHomeManagerModules }: {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "hmbak";
        home-manager.users.${saymyname}.imports = theosHomeManagerModules;
      };
    in
      dendriticModules // {

        darwinConfigurations.beauvoir = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs; };
          modules = [
            # nix-darwin config & Dendritic modules
            ./hosts/beauvoir/configuration.nix
            {
              imports = with self.modules.darwin; [
                darwin-base
                # modules/mac
                aerospace homebrew
              ];
            }

            # home-manager modules
            home-manager.darwinModules.home-manager
            (mkHomeManager {
              saymyname = "theopn"; # you're goddamn right
              theosHomeManagerModules = with self.modules.homeManager; [
                home-base
                nixvim

                # modules/cli-tools
                bat btop eza fastfetch fd fzf git lf ripgrep zoxide
                # modules/editor
                neovide vim
                # modules/shell
                fish starship zsh
                kitty { theo.kitty.font = { name = "ProggyClean Nerd Font"; size = 20; }; }
                # modules/web
                syncthing

              ];
            })
          ];
        };

        nixosConfigurations.wittgenstein = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            nixos-hardware.nixosModules.framework-amd-ai-300-series

            # nixOS config & Dendritic modules
            ./hosts/wittgenstein/configuration.nix
            {
              imports = with self.modules.nixos; [
                nixos-base
                # modules/linux
                fcitx printing podman tailscale udisks2 xdg-mime
                # modules/wm
                dconf niri swaylock
              ];
            }

            # home-manager modules
            home-manager.nixosModules.home-manager
            (mkHomeManager {
              saymyname = "theopn"; # you're goddamn right
              theosHomeManagerModules = with self.modules.homeManager; [
                home-base nixvim

                # modules/cli-tools
                bat btop eza fastfetch fd fzf git lf ripgrep zoxide
                # modules/editor
                neovide vim
                # modules/shell
                fish kitty starship zsh
                # modules/web
                syncthing

                # modules/linux
                easyeffects keychain nm-applet mate-polkit udiskie xdg-mime
                # modules/wm
                cliphist dconf dunst gammastep niri rofi swayidle swaylock theme waybar
                # modules/media
                mpv imv zathura
              ];
            })

          ];
        };
      };
}

