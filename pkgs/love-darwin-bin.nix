{
  lib,
  stdenv,
  fetchzip,
  makeWrapper,
}: let
  version = "11.5";
  url = "https://github.com/love2d/love/releases/download/${version}/love-${version}-macos.zip";
  sha256 = "sha256-6pz66mZMpAkMBtTPzfhFs0Ws8cYVxWjrSroy2xoYgYQ=";
in
  stdenv.mkDerivation {
    pname = "love-darwin-bin";
    inherit version;
    src = fetchzip {
      inherit url sha256;
    };

    nativeBuildInputs = [makeWrapper];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications
      cp -r $src $out/Applications/love.app
      makeWrapper $out/Applications/love.app/Contents/MacOS/love $out/bin/love

      runHook postInstall
    '';

    meta = {
      description = "Lua-based 2D game engine/scripting language";
      homepage = "https://love2d.org";
      changelog = "https://github.com/love2d/love/releases/";
      license = lib.licenses.zlib;
    };
  }
