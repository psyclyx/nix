{
  lib,
  pkgs,
  ...
}: let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in {
  programs = {
    ssh = {
      enable = true;
      compression = true;
      addKeysToAgent = "yes";
      extraOptionOverrides = lib.optionalAttrs isDarwin {"useKeychain" = "yes";};
      matchBlocks = {
        "github.com" = {
          identityFile = "~/.ssh/id_ed25519";
        };
        "gitlab.com" = {
          identityFile = "~/.ssh/id_psyclyx";
        };
        "psyclyx.xyz *.psyclyx.xyz" = {
          forwardAgent = true;
          identityFile = "~/.ssh/id_psyclyx";
        };
      };
    };
  };
}
