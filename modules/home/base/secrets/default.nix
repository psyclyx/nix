{inputs, config, ...}: let
  configHome = config.xdg.configHome;
  home = config.home.homeDirectory;
in {
  imports = [inputs.sops-nix.homeManagerModules.sops];
  sops = {
    age.keyFile = "${configHome}/sops/age/keys.txt";
    secrets = {
      ".ssh/id_psyclyx" = {
        sopsFile = ../secrets/ssh/psyclyx.json;
        key = "private_key";
        path = "${home}/.ssh/id_psyclyx";
      };
      ".ssh/id_alice157" = {
        sopsFile = ../secrets/ssh/alice157.json;
        key = "private_key";
        path = "${home}/.ssh/id_alice157";
      };
    };
  };
}
