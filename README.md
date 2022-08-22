# my .nixpkgs repository

This repository contains my .nixpkgs to setup and restore my configuration using nix home-manager.

### Prerequisites 

Since not all required packages are available via nixpkgs some are installed via brew beforehand.

```shell
brew install --cask iterm2 vscodium obsidian font-jetbrains-mono-nerd-font
brew install awscli awsume
```

### Install nix & home-manager

```shell
# install nix
sh <(curl -L https://nixos.org/nix/install)

nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --add https://nixos.org/channels/nixpkgs-unstable unstable
nix-channel --update

# if not on NixOS execute
export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}

# install home-manager
nix-shell '<home-manager>' -A install
```

### Clone this repository

```shell
rm -rf ~/.config/nixpkgs/
git clone https://github.com/f0x7C0/.nixpkgs.git ~/.config/nixpkgs/
```

### Apply nix home-manager configuration

```shell
home-manager switch
```

### Decrypt secrets

The secrets are en- / decrypted using GPG, which should be installed by now

```shell
git-crypt unlock
```

