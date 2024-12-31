{
  emacsPackages = epkgs:
    with epkgs; [
      # Emacs
      exec-path-from-shell
      no-littering
      undo-tree

      # Evil
      evil
      evil-collection
      evil-snipe
      general

      # Completion
      cape
      consult
      corfu
      embark
      embark-consult
      kind-icon
      marginalia
      orderless
      vertico

      # UI
      all-the-icons
      all-the-icons-nerd-fonts
      dashboard
      diminish
      doom-themes
      rainbow-delimiters
      which-key

      # Notes
      gptel
      org
      org-bullets
      org-roam

      # Development
      direnv
      eglot
      envrc
      flycheck
      magit
      projectile
      treesit-grammars.with-all-grammars
      vterm

      ## Languages

      ### Clojure
      cider
      clojure-mode

      ### Nix
      nix-ts-mode

      ### Zig
      zig-mode
    ];

  systemPackages = pkgs:
    with pkgs;
      [
        # UI
        fontconfig
        nerd-fonts.hack
        nerd-fonts.noto
        nerd-fonts.symbols-only

        # Development
        direnv
        git

        ## Search/Completion
        fd
        gnugrep
        ripgrep
        silver-searcher

        # Language support
        ## text
        ispell

        # clojure
        babashka
        clj-kondo
        cljfmt
        leiningen
        readline
        zlib

        # nix
        alejandra
        nixd

        # shell
        shellcheck
        shfmt

        # typescript
        eclint
        nodePackages.prettier
        nodePackages.typescript
        nodePackages.typescript-language-server
        nodejs

        # zig
        zls
      ]
      ++ lib.optionals stdenv.isDarwin []
      ++ lib.optionals stdenv.isLinux [];
}
