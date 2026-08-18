# Theo's Nix Flake

| ![niri-sc](https://raw.githubusercontent.com/theopn/haunted-tiles/refs/heads/main/assets/niri-sc.png) |
| :--:                                                                                                  |
| NixOS + Niri in Wittgenstein (Framework 13)                                                           |

I was peer-pressured into using Nix.
And I am glad I was; it turned out to be perfect for a control freak like me.

> [!NOTE]
> My [original dotfiles repository](https://github.com/nvim-mini/mini.nvim) isn't dead.
> I will backport any major changes there.
> Because you never know when the urge to distrohop will strike again.

## My Update Workflow

Every 2 weeks or so, I do:

1. Switch to the `flake-update-testing` branch.
2. Run `make update` to update `flake.lock`.
3. Iron out any breaking changes and implement new features.
4. Test the updated packages & any features I added for a week or so.
5. Merge the branch into `main`.
6. Repeat.


## Structure Overview

I use a mix of [the Dendritic Pattern](https://github.com/mightyiam/dendritic) and traditional Flake management.

- `/hosts`: Machine specific `configuration.nix` and `hardware-configuration.nix`.
    Typically includes low-level system configurations.
    Mirrors the default configuration as much as poissible.
- `/modules`: Shared modules (`flake-parts`) across multiple systems, organized by types.
    For example, my `polkit.nix` module enables Polkit globally in NixOS and configures `mate-polkit` in home-manager; **everything about Polkit lives in one file**.
    `import-tree` automatically scans the subdirectories of `/modules` and make them available (unless prefixed with `_`).
    Note that subdirectories are purely for organizational purpose; their names are not mentioned anywhere in the config.


### Adding a New System

First, read my [NixOS Minimal Installation with LUKS Encryption Guide](./nixos-minimal-install-w-luks.md) to 

1. Create a new directory in `/hosts` and copy `conifguration.nix` and `hardware-configuration.nix`.
    Keep the hardware config as stock as possible; `configuration.nix` should require a minimal modification (mostly taking unnecessary config out), reference existing files.
2. Create a new flake. For example, to create a new NixOS flake output:
    ```nix
    nixosConfigurations.hostname = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };
    modules = [
        nixos-hardware.nixosModules.framework-amd-ai-300-series

        # nixOS config & Dendritic modules
        ./hosts/wittgenstein/configuration.nix
        { imports = with self.modules.nixos; [ linux-base niri dconf polkit swaylock other-modules ]; }

        # home-manager modules
        home-manager.nixosModules.home-manager
        (mkHomeManager (with self.modules.homeManager; [
        base niri portals polkit-agent
        bat btop eza fd fzf git lf neovide ripgrep vim zoxide
        fastfetch fish kitty starship zsh nixvim
        ]))
      ];
    };
    ````
3. Run `make`!



## Flake Outputs (Machine)

- `beauvoir`: a `nix-darwin` module for my M4 Mac Mini.
- `wittgenstein`: a NixOS module for my Framework 13.




## `wittgenstein`

### Prerequisites


### Post-installation

Since I have no display manager, you will be dropped into a TTY upon boot.

1. Use `keychain_load` alias in Zsh to manually load SSH keys.
    I intentionally disabled Zsh integration to prevent blocking the login shell.
    Manual loading ensures the SSH agent is inherited by all child processes.
2. Use `niri-session` to launch Niri alongside necessary `systemd` services (swayidle, Waybar, etc., managed via the `niri.session` target).
3. Set the wallpaper and generated a cached lockscreen image using
    ```sh
    theo-set-wallpaper /path/to/any/image/that/is/accepted/in/imagemagick
    ```


## `beauvoir`

### Prerequisites

```sh
# Install Determinate Nix
curl -fsSL https://install.determinate.systems/nix | sh -s -- install

cd && git clone git@github.com:theopn/nix-conf.git
cd ~/nix-conf
nix run nix-darwin -- switch --flake .#beauvoir
```

### Post-installation

- Since I don't use a GUI wrapper, bookmark `http://127.0.0.1:8384/` (Syncthing web UI).

