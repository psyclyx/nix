{...}: {
  programs.git = {
    enable = true;
    userName = "psyclyx";
    userEmail = "me@psyclyx.xyz";
    iniContent = {"pull" = {"rebase" = true;};};
  };
}
