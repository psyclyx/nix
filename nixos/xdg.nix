{pkgs, ...}:
with pkgs; {
  services.pipewire.enable = true;
  xdg = {
    portal = {
      enable = true;
      wlr = {
        enable = true;
      };
      configPackages = [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
      extraPortals = [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
    };
  };
}
