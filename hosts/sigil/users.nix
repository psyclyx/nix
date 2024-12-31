{pkgs, ...}: {
  nix.settings.trusted-users = ["psyc"];
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
          "builders"
        ];
      };
    };
  };

  home-manager = {
    users = {
      psyc = {
        imports = [
	  ../../home/psyc-sigil.nix
        ];
      };
    };
  };
}
