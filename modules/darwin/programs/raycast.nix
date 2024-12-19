{ config, lib, pkgs, ... }:
{
  homebrew.casks = ["raycast"];
  system.defaults.CustomUserPreferences = {
        "com.apple.symbolicHotKeys.AppleSymbolicHotKeys.64".enabled = false; # disable spotlight
  };
}
