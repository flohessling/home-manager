# my nix home-manager repository

This repository contains my home-manager configuration to setup or restore my mac environment.

### Prerequisites 

Since not all required packages are available via nixpkgs some are installed via brew beforehand.

#### Install homebrew

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### Install homebrew formulae and casks

```shell
brew install --cask iterm2 vscodium obsidian postman font-jetbrains-mono-nerd-font
brew install awscli awsume 1password-cli
```

#### Install lunarvim

```shell
bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)
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
rm -rf ~/.config/home-manager/
git clone https://github.com/flohessling/.nixpkgs.git ~/.config/home-manager/
```

### Apply nix home-manager configuration

```shell
home-manager switch
```

### Decrypt secrets

The secrets are en- / decrypted using GPG, which should be installed by now

```shell
// with yubikey
git-crypt unlock

// with 1password
op document get .gitcrypt --force | git-crypt unlock -
```

---
### Upgrading nix 

Upgrading nix on macOS requires the restart of the daemon

```shell
sudo -i sh -c 'nix-channel --update && nix-env -iA nixpkgs.nix && launchctl remove org.nixos.nix-daemon && launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist'

```
### Troubleshooting nix

After upgrading macOS `/etc/zshrc` is reset and loses the Nix specific lines that have to be added again to get `nix` running again.

```shell
# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
   . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix
```

macOS updates also tend to reset the `pam.d/sudo` file to use touchID for sudo commands.
Adding this line to `/etc/pam.d/sudo` enables touchID for sudo password prompts:
```
auth       sufficient     pam_tid.so
```
