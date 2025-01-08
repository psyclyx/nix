{config, ...}: {
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  sops.secrets."wg-mullvad.conf" = {
    format = "binary";
    sopsFile = ./wg-mullvad.conf.enc;
  };
}
