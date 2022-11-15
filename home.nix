{ config, pkgs, lib, ... }:
let
  unstable = import <unstable> { config = { allowUnfree = true; }; };
  php = pkgs.php81.buildEnv { extraConfig = "memory_limit = 2G"; };
in
{
  home.stateVersion = "22.05";
  home.username = "f";
  home.homeDirectory = "/Users/f";
  home.sessionVariables = {
    EDITOR = "lvim";
  };

  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

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
    # unstable.awscli2
    unstable.ssm-session-manager-plugin
    temporal-cli
    glab
    docker-compose
    bitwarden-cli
    git-crypt
    direnv
    unstable.neovim
    natscli
    # pgcli
    nodejs
    nodePackages.pnpm
    php
    phpPackages.composer
    phpPackages.psalm
    phpPackages.phpstan
    wireguard-tools
    wireguard-go
    yubikey-manager
  ];

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.go = {
    enable = true;
    package = unstable.go_1_19;
    goPrivate = [ "gitlab.shopware.com" ];
    goPath = "code/go";
  };

  programs.gpg = {
    enable = true;
    scdaemonSettings = {
      disable-ccid = true;
    };
    publicKeys = [{
      source = ./home/gnupg/f.pub;
      trust = "ultimate";
    }];
  };

  programs.git = {
    enable = true;
    package = unstable.git;

    signing.key = "0x48F495E9FD7D11E2";
    signing.signByDefault = true;

    userEmail = "f.hessling@shopware.com";
    userName = "Flo Hessling";

    aliases = {
      rs = "restore --staged";
      amend = "commit --amend --reuse-message=HEAD";
    };

    extraConfig = {
      push.default = "simple";
      fetch.prune = true;
      init.defaultBranch = "main";
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
      theme = "trapd00r";
      plugins = ["git" "docker" "docker-compose" "aws"];
    };
    localVariables = {
      EDITOR = "lvim";
      PATH = "$PATH:$GOPATH/bin:$HOME/.local/bin";
    };
    sessionVariables = {
      DOCKER_BUILDKIT = 1;
    };
    shellAliases = {
      ykrestart = "gpgconf --reload scdaemon && gpgconf --kill gpg-agent && gpg-connect-agent updatestartuptty /bye";
      awsume = ". awsume";
      vi = "lvim";
      vim = "lvim";
      gpo = "git pull origin $(git_current_branch)";
      lg = "lazygit";
      wgup-staging = "sudo wg-quick up staging";
      wgup-prod = "sudo wg-quick up prod";
      wgdown-staging = "sudo wg-quick down staging";
      wgdown-prod = "sudo wg-quick down prod";
    };
    initExtra = ''
      # yubikey setup
      export GIT_SSH="/usr/bin/ssh"
      export GPG_TTY="$(tty)"
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      gpgconf --launch gpg-agent

      # custom scripts
      ${builtins.readFile ./home/zsh/scripts.sh}
    '';
  };

  home.file = {
    ".gnupg/pubkey.pub".source = config.lib.file.mkOutOfStoreSymlink ./home/gnupg/f.pub;
    ".gnupg/gpg-agent.conf".text = ''
      # https://github.com/drduh/config/blob/master/gpg-agent.conf
      # https://www.gnupg.org/documentation/manuals/gnupg/Agent-Options.html
      enable-ssh-support
      ttyname $GPG_TTY
      default-cache-ttl 60
      max-cache-ttl 120
      pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
    '';
    ".local/bin/dir_select".source = config.lib.file.mkOutOfStoreSymlink ./home/zsh/dir_select;
    ".local/bin/update-tf.sh".source = config.lib.file.mkOutOfStoreSymlink ./home/zsh/update-tf.sh;
    ".config/lvim/config.lua".source = config.lib.file.mkOutOfStoreSymlink ./home/lvim/config.lua;

    # secrets
    ".aws/config".source = config.lib.file.mkOutOfStoreSymlink ./secrets/aws/config;
    ".aws/credentials".source = config.lib.file.mkOutOfStoreSymlink ./secrets/aws/credentials;
    ".ssh/cloud".source = config.lib.file.mkOutOfStoreSymlink ./secrets/ssh/cloud;
    ".ssh/config".source = config.lib.file.mkOutOfStoreSymlink ./secrets/ssh/config;
    ".netrc".source = config.lib.file.mkOutOfStoreSymlink ./secrets/netrc;
    ".config/wireguard/staging.private-key.gpg".source = config.lib.file.mkOutOfStoreSymlink ./secrets/wireguard/staging.private-key.gpg;
    ".config/wireguard/prod.private-key.gpg".source = config.lib.file.mkOutOfStoreSymlink ./secrets/wireguard/prod.private-key.gpg;
  };
}
