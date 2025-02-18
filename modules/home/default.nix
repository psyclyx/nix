{
  name,
  email,
  modules,
  ...
}: {
  home.stateVersion = "23.11";
  fonts.fontconfig.enable = true;

  imports =
    [
      ./config.nix
      {my.user = {inherit name email;};}
    ]
    ++ modules;
}
