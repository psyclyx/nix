{pkgs, ...}:
pkgs.writeShellApplication {
  name = "generate-host-keys";
  runtimeInputs = with pkgs; [
    jq
    openssh
    sops
  ];
  text = builtins.readFile ./generate-host-keys.sh;
}
