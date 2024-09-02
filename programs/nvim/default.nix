{ pkgs, ... }:

{
  home.packages = [ pkgs.neovim ];
  home.file.".config/nvim/init.lua".source = ./init.lua;
}
