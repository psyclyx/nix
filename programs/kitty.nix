{pkgs, ...}:

{
  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
      enable_audio_bell = 0;
      resize_debounce_time = 0;
    };
  };
  home.packages = [ pkgs.kitty ];
}
