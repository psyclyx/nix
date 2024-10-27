{config, ...}: {
  sops = {
    enable = true;
    age.keyFile = config.xdg.configFile."sops/age/keys.txt";
    defaultSopsFile = ./sops.yaml;
  };
}
