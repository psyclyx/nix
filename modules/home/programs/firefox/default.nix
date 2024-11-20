{
  inputs,
  pkgs,
  ...
}: {
  programs = {
    firefox = {
      enable = true;
      package = pkgs.firefox-bin;
      profiles = {
        default = {
          id = 0;
          isDefault = true;
          extensions = import ./extensions.nix {
            inherit pkgs inputs;
          };
          settings = import ./settings.nix;
          search = import ./search.nix {inherit pkgs;};
          userChrome = builtins.readFile ./userChrome.css;
        };
      };
    };
  };
}
