{...}: {
  nix = {
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
