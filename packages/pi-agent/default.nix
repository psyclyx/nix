{
  lib,
  makeBinaryWrapper,
  symlinkJoin,
  pi-coding-agent,
  git,
  jq,
  ripgrep,
}:
let
  extensionDir = ./extensions/memory;
  extension = "${extensionDir}/index.ts";
in
symlinkJoin {
  name = "nixclyx-pi-${pi-coding-agent.version}";
  paths = [ pi-coding-agent ];
  nativeBuildInputs = [ makeBinaryWrapper ];

  postBuild = ''
    wrapProgram "$out/bin/pi" \
      --set PI_PACKAGE_DIR "${pi-coding-agent}/lib/node_modules/pi-monorepo" \
      --add-flags ${lib.escapeShellArg "--extension ${extension}"} \
      --prefix PATH : ${lib.makeBinPath [
        git
        jq
        ripgrep
      ]}
  '';

  passthru = {
    inherit extension;
    unwrapped = pi-coding-agent;
  };

  meta = pi-coding-agent.meta // {
    description = "Pi coding agent with nixclyx extensions";
    mainProgram = "pi";
  };
}
