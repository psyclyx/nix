{...}: {
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    optimise = {
      automatic = true;
      dates = ["05:00"];
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
