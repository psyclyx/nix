{pkgs, ...}: let
  package = pkgs.wezterm;
  shellIntegrationStr = ''
    source "${package}/etc/profile.d/wezterm.sh"
  '';
in {
  home.packages = [package];
  xdg.configFile = {
    "wezterm/appearance.lua".source = ./appearance.lua;
    "wezterm/keys.lua".source = ./keys.lua;
    "wezterm/util.lua".source = ./util.lua;
    "wezterm/wezterm.lua".source = ./wezterm.lua;
  };
  programs.bash.initExtra = shellIntegrationStr;
  programs.zsh.initExtra = shellIntegrationStr;
}
