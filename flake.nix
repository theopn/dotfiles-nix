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
      aspects = inputs.flake-parts.lib.mkFlake { inherit inputs; } (
        inputs.import-tree ./modules
      );

      username = "theopn";

      mkHomeManager = extraImports: {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "hmbak";
        home-manager.users.${username} = {
          imports = extraImports;
        };
      };
    in
      aspects // {
        darwinConfigurations.beauvoir = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs; };
          modules = [
            # nix-darwin config & Dendritic modules
            ./hosts/beauvoir/configuration.nix
            {
              imports = with self.modules.darwin; [
                  aerospace homebrew
                ];
            }

            # home-manager modules
            home-manager.darwinModules.home-manager
            (mkHomeManager (with self.modules.homeManager; [
              base
              bat btop eza fd fzf git lf ripgrep vim zoxide
              fastfetch fish starship zsh
              kitty neovide mpv imv zathura syncthing
              nixvim
            ]))
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
                niri dconf polkit swaylock linux-base
              ];
            }

            # home-manager modules
            home-manager.nixosModules.home-manager
            (mkHomeManager (with self.modules.homeManager; [
              base theme
              bat btop eza fd fzf git lf ripgrep vim zoxide
              fastfetch fish starship zsh

              kitty neovide mpv imv zathura syncthing keychain

              niri waybar polkit
              cliphist dunst easyeffects gammastep rofi swayidle swaylock udiskie
              nixvim
            ]))

          ];
        };
      };
}

