{pkgs, ...}: {
  users = {
    users = {
      psyc = {
        name = "psyc";
        home = "/home/psyc";
        shell = pkgs.zsh;
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "video"
          "networkmanager"
          "adbusers"
        ];
      };
    };
  };

  home-manager = {
    users = {
      psyc = {
        imports = [../../home/nixos.nix];
      };
    };
  };
}
