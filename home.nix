{ config, pkgs, lib, ... }:
let
  unstable = import <unstable> { config = { allowUnfree = true; }; };
in
{
  home.stateVersion = "22.05";
  home.username = "f";
  home.homeDirectory = "/Users/f";

  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    nixpkgs-fmt
    zsh
    oh-my-zsh
    git
    htop
    curl
    wget
    unzip
    zip
    jq
    fzf
    gnupg
    unstable.awscli2
    unstable.terraform_1
    glab
    docker-compose
    bitwarden-cli
    git-crypt
    direnv
    dig
    rnix-lsp
    unstable.neovim
    nodejs
  ];

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.go = {
    enable = true;
    package = unstable.go_1_18;
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
      EDITOR = "nvim";
      PATH = "$PATH:$GOPATH/bin:$HOME/.local/bin";
    };
    sessionVariables = {
      DOCKER_BUILDKIT = 1;
    };
    shellAliases = {
      ykrestart = "gpgconf --reload scdaemon && gpgconf --kill gpg-agent && gpg-connect-agent updatestartuptty /bye";
      awsume = ". awsume";
      vi = "nvim";
      vim = "nvim";
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
    ".gnupg/gpg-agent.conf".source = config.lib.file.mkOutOfStoreSymlink ./home/gnupg/gpg-agent.conf;
    ".local/bin/dir_select".source = config.lib.file.mkOutOfStoreSymlink ./home/zsh/dir_select;

    # TODO: implement secrets
  };
}