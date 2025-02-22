{
  inputs,
  pkgs,
  config,
  ...
}: let
  configHome = config.xdg.configHome;
  home = config.home.homeDirectory;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in {
  imports = [inputs.sops-nix.homeManagerModules.sops];
  sops = {
    age.keyFile =
      if isDarwin
      then "${home}/Library/Application Support/sops/age/keys.txt"
      else "${configHome}/sops/age/keys.txt";
    secrets = {
      ".ssh/id_psyclyx" = {
        sopsFile = ./ssh/psyclyx.json;
        key = "private_key";
        path = "${home}/.ssh/id_psyclyx";
      };
      ".ssh/id_alice157" = {
        sopsFile = ./ssh/alice157.json;
        key = "private_key";
        path = "${home}/.ssh/id_alice157";
      };
    };
  };
}
