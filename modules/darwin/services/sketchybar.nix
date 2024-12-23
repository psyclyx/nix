{pkgs, ...}: {
  services.sketchybar = {
    enable = true;
    config = ./sketchybarrc.sh;
  };
}
