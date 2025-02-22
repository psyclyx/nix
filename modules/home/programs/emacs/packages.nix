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
      evil-easymotion
      evil-org
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
      all-the-icons-nerd-fonts
      dashboard
      doom-modeline
      doom-themes
      mixed-pitch
      rainbow-delimiters
      solaire-mode
      which-key

      # Notes
      gptel
      org
      org-superstar
      org-roam

      # Development
      apheleia
      direnv
      eglot
      envrc
      flycheck
      lispy
      lispyville
      magit
      persp-projectile
      perspective
      projectile
      treesit-grammars.with-all-grammars
      vterm

      ## Languages

      ### Clojure
      cider
      clojure-mode

      ### Nix
      nix-ts-mode

      ### Lua
      lua-mode

      ### Zig
      zig-mode
    ];

  systemPackages = pkgs:
    with pkgs;
      [
        # UI
        etBook
        fontconfig
        nerd-fonts.hack
        nerd-fonts.noto
        nerd-fonts.symbols-only
        symbola
        dejavu_fonts
        noto-fonts

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
