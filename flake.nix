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

    nixvim = {
      url = "github:nix-community/nixvim";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, nix-darwin, home-manager, nixvim, ... }:
    let
      mkHomeManager = username : {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "hmbak";
        home-manager.users."${username}" = {
          imports =[
            nixvim.homeModules.nixvim
            ./home-manager/home.nix
          ];
        };
      };
    in
  {

    darwinConfigurations.beauvoir = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";

      modules = [
        ./hosts/beauvoir/configuration.nix
        home-manager.darwinModules.home-manager
        (mkHomeManager "theopn")
      ];

    };

    nixosConfigurations.wittgenstein = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        nixos-hardware.nixosModules.framework-amd-ai-300-series
        ./hosts/wittgenstein/configuration.nix
        home-manager.nixosModules.home-manager
        (mkHomeManager "theopn")
        {
          home-manager.users.theopn = {
            imports =[ ./home-manager/linux.nix ];
          };
        }
      ];

    };

  };
}
