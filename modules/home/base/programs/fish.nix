{ pkgs, lib, ... }:
{

  programs = {
    fish = {
      enable = true;
      shellInit = lib.optionalString pkgs.stdenv.isDarwin ''
        eval (/opt/homebrew/bin/brew shellenv)
      '';
      interactiveShellInit = ''
        set -g fish_key_bindings fish_vi_key_bindings
      '';
    };
    starship = {
      enable = true;
      enableTransience = true;
      enableZshIntegration = false;
      enableFishIntegration = true;
    };
  };
}
