{pkgs, ...}: {
  services.sketchybar = {
    enable = false;
    extraPackages = with pkgs; [jq gh];
  };
  fonts = [pkgs.sketchybar-app-font];
}
