{...}: {
  nix = {
    substituters = [
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    gc = {
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };
    optimise = {
      automatic = true;
      interval.Day = 7;
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
