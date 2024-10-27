{config, ...}: {
  sops = {
    age.keyFile = config.xdg.configFile."sops/age/keys.txt";
    defaultSopsFile = ../../.sops.yaml;
    secrets = let
      home = config.home.homeDirectory;
    in {
      "ssh/psyclyx.json" = {
        path = "${home}/.ssh/id_psyclyx";
      };
      "ssh/alice157.json" = {
        path = "${home}/.ssh/id_alice157";
      };
    };
  };
}
