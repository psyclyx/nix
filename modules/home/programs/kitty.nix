{ ... }:
{
  programs.kitty = {
    enable = true;

    shellIntegration.mode = "no-rc";

    themeFile = "Doom_One";
    font = {
      size = 14;
      name = "NotoMono Nerd Font Mono";
    };
  };
}
