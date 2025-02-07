{
  config,
  lib,
  ...
}: {
  programs.git = {
    enable = lib.mkDefault true;
    userName = lib.mkDefault config.my.user;
    userEmail = lib.mkDefault config.my.email;
    iniContent = lib.mkMerge [{"pull" = {"rebase" = true;};}];
  };
}
