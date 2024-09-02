{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    package = pkgs.kitty;
    settings = {
      confirm_os_window_close = 0;
      enable_audio_bell = 0;
      resize_debounce_time = 0;
    };
  };
}
