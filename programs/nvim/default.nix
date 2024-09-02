{ pkgs, ... }:

{
  home.packages = [ pkgs.neovim ];
  home.file.".config/nvim/init.lua".source = ./init.lua;
  home.file.".config/nvim/coc-settings.json".source = ./coc-settings.json;
  home.file.".config/nvim/lua".source = ./lua;
}
