{pkgs, darwin-emacs, darwin-emacs-packages, homebrew-bundle, homebrew-core, homebrew-cask, ...}:

let
  userName = "psyc";
  userHome = "/Users/psyc";
in
{
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

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = userName;
    mutableTaps = false;
    taps = {
      "homebrew/homebrew-bundle" = homebrew-bundle;
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
    };
  };

  networking.hostName = "halo";

  security.pam.enableSudoTouchIdAuth = true;

  services.nix-daemon.enable = true;

  services.link-apps = {
    enable = true;
    inherit userName userHome;
  };

  services.skhd.enable = false;
  services.yabai.enable = false;
  services.spacebar = {
    package = pkgs.spacebar;
    enable = false;
    config = {
      position = "top";
    };
  };
  
  users.users.psyc = {
    name = userName;
    home = userHome;
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
  programs.direnv.enable = true;

  environment.systemPackages = with pkgs; [ jq clojure neovim tmux nodejs ];

  home-manager.users.psyc = {
    home.stateVersion = "23.11";
    home.shellAliases = {
      ls = "ls --color=auto";
      gs = "git status";
      gdh = "git diff HEAD";
    };
    #home.file.".skhdrc".source = ../config/psyc/skhdrc;
    #home.file.".yabairc".source = ../config/psyc/yabairc;
    #home.file.".yabairc".executable = true;
    imports = [
      ../programs/zsh
      ../programs/kitty.nix
      ../programs/emacs
    ];
  };
}
