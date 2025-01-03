{pkgs, ...}: {
  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    alejandra
    babashka
    cargo
    clj-kondo
    cljstyle
    clojure
    clojure-lsp
    fd
    htop
    htop
    jq
    leiningen
    lua-language-server
    lua
    love-darwin-bin
    maven
    nerd-fonts.hack
    nerd-fonts.noto
    nixd
    nodejs
    python3
    ripgrep
    rustc
    source-code-pro
    vscode
  ];

  fonts.fontconfig.enable = true;

  imports = [
    ../modules/home/services/syncthing.nix
    ../modules/home/programs/git
    ../modules/home/programs/kitty.nix
    ../modules/home/programs/nvim
    ../modules/home/programs/emacs
    ../modules/home/programs/signal.nix
    ../modules/home/programs/zsh
  ];


}
