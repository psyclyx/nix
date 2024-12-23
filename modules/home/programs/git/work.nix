{...}: {
  programs.git = {
    enable = true;
    userName = "$fixme$";
    userEmail = "$fixme$";
    iniContent = {"pull" = {"rebase" = true;};};
  };
}
