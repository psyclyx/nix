{pkgs, ...}: {
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

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

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
    jq
    leiningen
    maven
    neovim
    nodejs
    openjdk11
    python3
    ripgrep
    rustc
    tmux
    tree
    zoxide
  ];

  homebrew = {
    enable = true;
    brews = [];
    casks = [
      "discord"
      "firefox"
      "gimp"
      "obsidian"
      "orcaslicer"
      "rectangle"
      "remarkable"
      "signal"
      "spotify"
      "zoom"
    ];
    caskArgs.no_quarantine = true;
    global.autoUpdate = false;
    onActivation = {
      autoUpdate = false;
      cleanup = "zap";
      upgrade = true;
    };
  };
  services.nix-daemon.enable = true;

  programs.direnv.enable = true;
  programs.zsh.enable = true;
}
