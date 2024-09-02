{pkgs, ...}: {
  nix = {
    package = pkgs.nix;
    gc = {
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
    '';
  };

  home-manager.useGlobalPkgs = true;

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

  services.nix-daemon.enable = true;

  programs.direnv.enable = true;
  programs.zsh.enable = true;
}
