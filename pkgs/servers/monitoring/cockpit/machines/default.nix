{ lib
, stdenv
, fetchgit
, fetchFromGitHub
, autoreconfHook
, bashInteractive
, coreutils
, gettext
, git
, glib
, glibc
, glib-networking
, gnused
, makeWrapper
, nodejs
, ripgrep
, pkgs
, findutils
, pkg-config
}:

let
in

stdenv.mkDerivation rec {
  pname = "machines";
  version = "293";
  src = [
    (fetchgit {
      url = "https://github.com/cockpit-project/cockpit-machines.git";
      name = "cockpit-machines";
      rev = "refs/tags/293";
      sha256 = "sha256-01Z6/KVkSo86beE8evT5EY1A+sbk+FUaTQ7jTNPAHls=";
      fetchSubmodules = true;
    })
    (fetchFromGitHub {
    owner = "cockpit-project";
    name  = "cockpit";
    repo = "cockpit";
    rev = "355c0aa59e3991243e10a61183e62ea129d3261a";
    sha256 = "sha256-Lx4Gh7NlkEXHdiaNCKVZ/kUwX0DzZHHTH2Xz8KxxFQo=";
    fetchSubmodules = true;
    })
  ];

  nativeBuildInputs = [
    makeWrapper
    findutils
    gettext
    git
    nodejs
    pkg-config
    ripgrep
  ];

  postPatch = ''
    '';

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)
    mkdir pkg tools
    cp ${./package-lock.json} package-lock.json
    ln -s ../../cockpit/tools/git-utils.sh ./tools/git-utils.sh
    ln -s ../../cockpit/tools/node-modules ./tools/node-modules
    ln -s ../../cockpit/tools/make-bots ./tools/make-bots
    ln -s ../../cockpit/pkg/lib ./pkg/lib
    ln -s ../../cockpit/test/common ./test/common
    ln -s ../../cockpit/test/static-code ./test/static-code
    NODE_ENV=production ${nodejs}/bin/node build.js

    runHook postBuild
  '';

  sourceRoot = "cockpit-machines";

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r dist/* $out/
    cp org.cockpit-project.machines.metainfo.xml $out/

    runHook postInstall
  '';

  postBuild = ''
  '';

  fixupPhase = ''
  '';

  checkInputs = [
  ];

  checkPhase = ''
  '';

  meta = with lib; {
    description = "This is the Cockpit user interface for virtual machines.";
    homepage = "https://cockpit-project.org/";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ lucasew ];
  };
}
