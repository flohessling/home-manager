{ config, pkgs, lib, ... }:
{
  imports = [
    <home-manager/nix-darwin>
  ];

  environment.systemPackages = with pkgs; [ 
  # TODO: configure neovim
  #  (neovim.override {
  #    vimAlias = true;
  #    configure = {
  #      packages.myPlugins= with vimPlugins; {
  #        start = [ vim-go vim-nix ]
  #        opt = [ ];
  #      };
  #      customRC = ''
  #        " custom vimrc goes here
  #      '';
  #    };
  #  })
  ];

  # auto upgrade nix package and the daemon service
  services.nix-daemon.enable = true;

  # create /etc/zshrc that loads the nix-darwin environment
  programs.zsh.enable = true;

  # backwards compatibility, please read the changelog before changing
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  users.users.f = {
    name = "f";
    home = "/Users/f";
  };

  home-manager.useUserPackages = true;
  home-manager.users.f = ./home.nix;

  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
     recursive
     (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];


  # Add ability to used TouchID for sudo authentication
  # security.pam.enableSudoTouchIdAuth = true;

  system.defaults.NSGlobalDomain.InitialKeyRepeat = 100;
  system.defaults.NSGlobalDomain.KeyRepeat = 250;
}
