{
  inputs,
  pkgs,
  ...
}: let
  inherit (inputs) mac-app-util;
in {
  nix = {
    gc = {
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };
    optimise = {
      automatic = true;
      interval.Day = 7;
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  security.pam.enableSudoTouchIdAuth = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    sharedModules = [mac-app-util.homeManagerModules.default];
  };

  environment.systemPackages = with pkgs; [
    alejandra
    babashka
    cargo
    clj-kondo
    cljstyle
    clojure
    clojure-lsp
    fd
    htop
    git
    jq
    leiningen
    lua-language-server
    maven
    neovim
    nixd
    nodejs
    openjdk11
    python3
    ripgrep
    rustc
    tmux
    tree
    zoxide
  ];

  homebrew.casks = [
    "firefox"
    "obsidian"
    "rectangle"
    "spotify"
    "iterm2"
    "zoom"
  ];

  services.nix-daemon.enable = true;

  programs.zsh = {
    enable = true;
    enableGlobalCompInit = false;
  };
}
