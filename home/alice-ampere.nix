{pkgs, ...}: {
  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    nerd-fonts.noto
    htop
    vscode
    alejandra
    babashka
    cargo
    clj-kondo
    cljstyle
    clojure
    clojure-lsp
    fd
    htop
    jq
    leiningen
    lua-language-server
    maven
    nixd
    nodejs
    openjdk11
    python3
    ripgrep
    rustc
  ];

  fonts.fontconfig.enable = true;

  imports = [
    ../modules/home/programs/git/work.nix
    ../modules/home/programs/kitty.nix
    ../modules/home/programs/nvim
    ../modules/home/programs/emacs
    ../modules/home/programs/zsh
    ../modules/home/programs/zsh/work.nix
  ];
}
