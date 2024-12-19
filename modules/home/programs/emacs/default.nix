{pkgs, ...}: let
  buildEmacs = (pkgs.emacsPackagesFor pkgs.emacs-29).emacsWithPackages;
  treesitGrammars =
    (pkgs.emacsPackagesFor pkgs.emacs-29).treesit-grammars.with-all-grammars;
  emacs = buildEmacs (epkgs: with epkgs; [vterm treesitGrammars]);
in {
  home.packages = with pkgs; [
    alejandra
    clj-kondo
    coreutils-prefixed
    emacs
    eclint
    emacs
    fd
    gnugrep
    ispell
    multimarkdown
    nerd-fonts.noto
    nerd-fonts.symbols-only
    nodePackages.prettier
    nodePackages.typescript-language-server
    nodePackages.typescript
    nixd
    nodejs_23
    ripgrep
    shellcheck
    fontconfig
    shfmt
  ];

  home.file = {
    # tree-sitter subdirectory of the directory specified by user-emacs-directory
    ".config/emacs/.local/cache/tree-sitter".source = "${treesitGrammars}/lib";
  };
}
