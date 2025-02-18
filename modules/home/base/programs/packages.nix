{pkgs, ...}: {
  home.packages = with pkgs;
  [
    # clojure
    babashka
    clj-kondo
    cljstyle
    clojure
    clojure-lsp
    leiningen
    maven

    # js
    nodejs

    # lua
    love-darwin-bin
    lua
    lua-language-server

    # nix
    alejandra
    nixd
    nixfmt

    # python
    python3

    # rust
    cargo
    rustc

    # tools
    fd
    htop
    jq
    ripgrep

    # zig
    zig
    zls
  ];
}
