# Theo's Nix Flake

| ![niri-sc](https://raw.githubusercontent.com/theopn/haunted-tiles/refs/heads/main/assets/niri-sc.png) |
| :--:                                                                                                  |
| NixOS + Niri on `wittgenstein` (my Framework 13)                                                           |

I was peer-pressured into using Nix (and later the Dendritic Pattern).
And I am glad I was; it turned out to be perfect for a control freak like me.

> [!NOTE]
> My [original dotfiles repository](https://github.com/theopn/dotfiles) isn't dead.
> I will backport any major changes there.
> Because you never know when the urge to distrohop will strike again.


## Hosts

| Host           | Platform       | User(s)  | Notes                                     |
| -------------- | -------------- | -------- | ----------------------------------------- |
| `beauvoir`     | macOS (ARM)    | `theopn` | M4 Mac Mini                               |
| `wittgenstein` | NixOS (x86_64) | `theopn` | Framework Laptop 13 (Ryzen ~AI~ 5 340)    |


## My Update Workflow

Roughly every 2 weeks:

1. Switch to the `flake-update-testing` branch.
2. Run `make update` to update `flake.lock`.
3. Iron out any breaking changes and implement new features.
4. Test the updated packages features for about a week or two.
5. Merge the branch into `main`.
6. Repeat.


## Structure Overview

I use a mix of [the Dendritic Pattern](https://github.com/mightyiam/dendritic) and traditional Flake management.

```
$ tree
.
├── flake.nix
├── hosts
│   ├── beauvoir
│   │   └── configuration.nix
│   └── wittgenstein
│       ├── configuration.nix
│       └── hardware-configuration.nix
└── modules
    ├── base
    │   └── modules...
    ├── cli-tools
    │   └── modules...
    ├── mac
    │   └── modules...
    └── shell
        └── more-modules...
```

- `/hosts`: Machine-specific `configuration.nix` and `hardware-configuration.nix` files.
    Typically includes low-level, system-specific configuration.
    Their structures mirror the auto-generated configurations as closely as possible.
- `/modules`: Shared modules across multiple systems, organized by features.
    For example, the `desktop/polkit.nix` module enables Polkit globally in NixOS and configures `mate-polkit` in Home Manager; **everything about Polkit lives in one file**.
    `import-tree` automatically scans subdirectories of `/modules` and makes them available (unless prefixed with `_`).
    Note that subdirectories are purely for organizational purposes; their folder names are not referenced anywhere in the config.

See [my blog post about the partial Dendritic pattern](https://theopark.me/blog/2026-08-19-partial-dendritic-pattern/) for more information.

## Adding a New Host

### Installing Nix(OS)

- **NixOS:** Read my [NixOS Minimal Installation with LUKS Encryption Guide](./nixos-minimal-install-w-luks.md).
- **nix-darwin:**
    ```sh
    # Install Determinate Nix
    curl -fsSL https://install.determinate.systems/nix | sh -s -- install

    # Clone configuration and bootstrap
    cd && git clone git@github.com:theopn/nix-conf.git
    cd ~/nix-conf
    nix run nix-darwin -- switch --flake .#beauvoir
    ```

### Adding a New Flake Output

1. Create a new directory in `/hosts` and copy over `configuration.nix` and `hardware-configuration.nix`.
    Keep the hardware config as stock as possible; `configuration.nix` should require minimal modification (reference existing host configurations as needed).
2. Define the new host output in `flake.nix`. For example, to add a new NixOS configuration:
    ```nix
    nixosConfigurations.theosNewFancyLaptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
            # Find your hardware module at: https://github.com/NixOS/nixos-hardware
            nixos-hardware.nixosModules.the-laptop

            # NixOS config
            ./hosts/theosNewFancyLaptop/configuration.nix

            # Dendritic modules for NixOS
            {
                imports = with self.modules.nixos; [
                nixos-base fonts
                other nixos related modules
                ];
            }

            # Dendritic modules for HM
            home-manager.nixosModules.home-manager
            (mkHomeManager {
                saymyname = "theopn"; # you're goddamn right
                theosHomeManagerModules = with self.modules.homeManager; [
                home-base fonts nixvim

                other home manager modules for this system
                ];
              })
        ];
    };
    ````
3. Run `make`!


### Post-installation

Since I do not use a display manager, you will be dropped into a TTY (with a beautiful Terminus font) upon boot.

1. Use the `keychain_load` alias in Zsh to manually load SSH keys.
    I intentionally disabled Zsh integration to prevent blocking the login shell.
    Manual loading ensures the SSH agent is inherited by all child processes.
2. Use `niri-session` to launch Niri alongside necessary `systemd` services (swayidle, Waybar, etc., managed via the `niri.session` target).
3. Set the wallpaper and generate a cached lockscreen image using:
    ```sh
    theo-set-wallpaper /path/to/any/image/accepted/by/imagemagick
    ```

The following files are not reproduced by Nix:

- Private SSH keys in `~/.ssh`
- My personal files in `~/nas` (mirrored to my NAS via Syncthing)
- Cloned repositories in `~/cloned` (hosted on GitHub, mirrored to GitLab)

Any other files on my system simply do not exist to me (at least mentally).

> *It’s all a "fugayzi", you know what a fugayzi is?*
>
> *Fugayzi, fugazi. It's a whazy. It's a woozy. It's fairy dust.*
> *It doesn't exist. It's never landed. It is no matter. It's not on the elemental chart.*
> *It's not f\*\*\*ing real!*
>
> -- Matthew McConaughey as Mark Hanna, *The Wolf of Wall Street*

