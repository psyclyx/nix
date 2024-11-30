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
      extraOptionOverrides =
        {"UpdateHostKeys" = "no";}
        // lib.optionalAttrs isDarwin {"useKeychain" = "yes";};
      matchBlocks = {
        "alice157.github.com" = {
          identityFile = "~/.ssh/id_alice157";
          hostname = "github.com";
        };
        "psyclyx.github.com" = {
          identityFile = "~/.ssh/id_psyclyx";
          hostname = "github.com";
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
