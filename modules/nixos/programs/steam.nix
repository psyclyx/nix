{pkgs, ...}:
{
  programs.gamescope.enable = true;
  programs.steam = {
    gamescopeSession.enable = true;
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraPackages = with pkgs; [gamescope bumblebee glxinfo];
    package = pkgs.steam.override {
     withPrimus = true;
  };
  };
}
