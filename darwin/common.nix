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
    clojure
    fd
    jq
    neovim
    nodejs
    ripgrep
    tmux
  ];

  services.nix-daemon.enable = true;

  programs.direnv.enable = true;
  programs.zsh.enable = true;
}
