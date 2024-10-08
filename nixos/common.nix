{
  inputs,
  pkgs,
  ...
}: {
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    optimise = {
      automatic = true;
      dates = ["05:00"];
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
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

  programs.zsh = {
    enable = true;
    enableGlobalCompInit = false;
  };

  imports = [
    ./fonts.nix
    ./xdg.nix
  ];
}
