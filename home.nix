{ config, pkgs, lib, ... }:
let
  unstable = import <unstable> { config = { allowUnfree = true; }; };
  php = pkgs.php82.buildEnv { extraConfig = "memory_limit = 2G"; };
in
{
  home.stateVersion = "23.11";
  home.username = "f";
  home.homeDirectory = "/Users/f";
  home.sessionVariables = { EDITOR = "nvim"; };

  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

  # neovim nightly
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
        url = "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz";
        }))
  ];

  home.packages = with pkgs; [
    zsh
    oh-my-zsh
    htop
    curl
    wget
    unzip
    ripgrep
    zip
    jq
    fzf
    gnupg
    tmux
    bat
    tldr
    tree
    ffmpeg
    lazygit
    unstable.ssm-session-manager-plugin
    temporal-cli
    glab
    docker-compose
    docker-client
    git-crypt
    direnv
    # unstable.neovim
    neovim-nightly
    natscli
    kubectl
    nodejs
    nodePackages.pnpm
    php
    phpPackages.composer
    phpPackages.psalm
    wireguard-tools
    wireguard-go
    yubikey-manager
    speedtest-cli
    postgresql
    mysql80
    nmap
    unstable.shopware-cli
    coreutils-prefixed
  ];

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.go = {
    enable = true;
    package = pkgs.go_1_22;
    goPrivate = [ "gitlab.shopware.com" ];
    goPath = "code/go";
  };

  programs.gpg = {
    enable = true;
    scdaemonSettings = {
      disable-ccid = true;
    };
    publicKeys = [{
      source = ./apps/gnupg/f.pub;
      trust = "ultimate";
    }];
  };

  programs.git = {
    enable = true;
    package = unstable.git;

    # signing.key = "0x48F495E9FD7D11E2";
    signing.key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDn2PfoRVF81hGahkDlH0D6LyLzf4S8CbDHQku0aK+Eu";
    signing.signByDefault = true;

    userEmail = "f.hessling@shopware.com";
    userName = "Flo Hessling";

    aliases = {
      rs = "restore --staged";
      amend = "commit --amend --reuse-message=HEAD";
      pf = "push --force-with-lease";
    };

    extraConfig = {
      push.default = "simple";
      fetch.prune = true;
      init.defaultBranch = "main";
      gpg = {
              format = "ssh";
              ssh = {
                      program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
                      allowedSignersFile = "~/.ssh/allowed_signers";
                  };
          };
    };

    ignores = [
      ".DS_Store"
      ".AppleDouble"
      ".LSOverride"

      "._*"

      ".DocumentRevisions-V100"
      ".fseventsd"
      ".Spotlight-V100"
      ".TemporaryItems"
      ".Trashes"
      ".VolumeIcon.icns"
      ".com.apple.timemachine.donotpresent"
      ".AppleDB"
      ".AppleDesktop"
      "Network Trash Folder"
      "Temporary Items"
      ".apdisk"
    ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = false;
    oh-my-zsh = {
      enable = true;
      theme = "oxide";
      plugins = ["git" "docker" "docker-compose" "aws"];
      custom = "$HOME/.oh-my-zsh/themes";
    };
    localVariables = {
      EDITOR = "nvim";
      PATH = "$PATH:$GOPATH/bin:$HOME/.local/bin";
    };
    sessionVariables = {
      DOCKER_BUILDKIT = 1;
      XDG_CONFIG_HOME = "$HOME/.config";
      MANPAGER = "nvim +Man!";
    };
    shellAliases = {
      hm = "home-manager";
      cdhm = "cd ~/.config/home-manager";
      ehm = "v ~/.config/home-manager/home.nix";
      cdnotes = "cd ~/notes";
      todo = "v ~/notes/home.md";
      sso = "aws sso login --sso-session root";
      cat = "bat -pp --theme \"base16\"";
      bcat = "bat --theme \"base16\"";
      # ykrestart = "gpgconf --reload scdaemon && gpgconf --kill gpg-agent && gpg-connect-agent updatestartuptty /bye";
      v = "nvim";
      vi = "nvim";
      vim = "nvim";
      gpo = "git pull origin $(git_current_branch)";
      lg = "lazygit";
      k = "kubectl";
      wgup-staging = "sudo wg-quick up staging";
      wgup-prod = "sudo wg-quick up prod";
      wgdown-staging = "sudo wg-quick down staging";
      wgdown-prod = "sudo wg-quick down prod";
      tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
    };
    initExtra = ''
      # custom secret scripts
      ${builtins.readFile ./secrets/zsh/scripts.sh}
    '';
  };

  home.file = {
    ".gnupg/pubkey.pub".source = config.lib.file.mkOutOfStoreSymlink ./apps/gnupg/f.pub;
    ".gnupg/gpg-agent.conf".text = ''
      # https://github.com/drduh/config/blob/master/gpg-agent.conf
      # https://www.gnupg.org/documentation/manuals/gnupg/Agent-Options.html
      enable-ssh-support
      ttyname $GPG_TTY
      default-cache-ttl 60
      max-cache-ttl 120
      pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
    '';
    ".ssh/allowed_signers".text = "f.hessling@shopware.com namespaces=\"git\" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDn2PfoRVF81hGahkDlH0D6LyLzf4S8CbDHQku0aK+Eu";
    ".local/bin/day".source = config.lib.file.mkOutOfStoreSymlink ./apps/zsh/day;
    ".local/bin/note".source = config.lib.file.mkOutOfStoreSymlink ./apps/zsh/note;
    ".local/bin/dir_select".source = config.lib.file.mkOutOfStoreSymlink ./apps/zsh/dir_select;
    ".local/bin/update-tf.sh".source = config.lib.file.mkOutOfStoreSymlink ./apps/zsh/update-tf.sh;
    ".local/bin/update-tg.sh".source = config.lib.file.mkOutOfStoreSymlink ./apps/zsh/update-tg.sh;
    ".config/lvim/config.lua".source = config.lib.file.mkOutOfStoreSymlink ./apps/lvim/config.lua;
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink ./apps/nvim;
    ".oh-my-zsh/themes/oxide.zsh-theme".source = config.lib.file.mkOutOfStoreSymlink ./apps/zsh/theme/oxide.zsh-theme;

    # secrets
    ".aws/config".source = config.lib.file.mkOutOfStoreSymlink ./secrets/aws/config;
    ".aws/no-sso-config".source = config.lib.file.mkOutOfStoreSymlink ./secrets/no-sso-config;
    ".aws/credentials".source = config.lib.file.mkOutOfStoreSymlink ./secrets/aws/credentials;
    ".ssh/cloud".source = config.lib.file.mkOutOfStoreSymlink ./secrets/ssh/cloud;
    ".ssh/config".source = config.lib.file.mkOutOfStoreSymlink ./secrets/ssh/config;
    ".netrc".source = config.lib.file.mkOutOfStoreSymlink ./secrets/netrc;
    ".config/wireguard/staging.private-key.gpg".source = config.lib.file.mkOutOfStoreSymlink ./secrets/wireguard/staging.private-key.gpg;
    ".config/wireguard/prod.private-key.gpg".source = config.lib.file.mkOutOfStoreSymlink ./secrets/wireguard/prod.private-key.gpg;
  };
}
