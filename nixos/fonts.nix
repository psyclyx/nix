{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      (nerdfonts.override {fonts = ["FiraCode" "Noto"];})
      font-awesome
      lato
      liberation_ttf
      open-sans
      roboto
      ubuntu_font_family
      twitter-color-emoji
    ];

    fontconfig = {
      defaultFonts = {
        monospace = ["NotoMono Nerd Font Mono"];
        serif = ["NotoSerif Nerd Font"];
        sansSerif = ["NotoSans Nerd Font"];
        emoji = ["Twitter Color Emoji"];
      };
    };
  };
}
