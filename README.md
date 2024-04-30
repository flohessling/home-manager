# My Nix Home Manager Repository (dotfiles)

This repository contains my home-manager configuration to setup or restore my mac environment.

### Prerequisites 

Since not all required packages are available via nixpkgs some are installed via brew beforehand.

To run containers download and install orbstack from https://orbstack.dev 

#### Install homebrew

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### Install homebrew formulae and casks

```shell
brew install --cask iterm2 vscodium obsidian postman font-jetbrains-mono-nerd-font
brew install awscli awsume 1password-cli
```

### Install nix & home-manager

```shell
# install nix
bash <(curl -L https://nixos.org/nix/install) --daemon

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
git clone https://github.com/flohessling/home-manager.git ~/.config/home-manager/
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

First check which Nix version will be installed (using unstable channel):

```shell
nix-shell -p nix -I nixpkgs=channel:nixpkgs-unstable --run "nix --version"
```

Then upgrade Nix and restart the daemon:

```shell
sudo nix-env --install --file '<nixpkgs>' --attr nix -I nixpkgs=channel:nixpkgs-unstable
sudo launchctl remove org.nixos.nix-daemon
sudo launchctl load /Library/LaunchDaemons/org.nixos.nix-daemon.plist
```

After the last update it was necessart to execute `nix-env --install --attr nix` without sudo to really switch to the new version.

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
