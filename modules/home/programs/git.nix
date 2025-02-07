{config, lib, ...}: {
  programs.git = {
    enable = true;
    userName = lib.mkDefault config.my.user;
    userEmail = lib.mkDefault config.my.email;
    iniContent = {"pull" = {"rebase" = true;};};
  };
}
