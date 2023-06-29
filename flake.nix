{
  description = "A workbench for writing toy implementations of distributed systems";

  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-utils.url = github:numtide/flake-utils;
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.default = with pkgs; stdenv.mkDerivation {
          name = "maelstrom";
          version = "0.2.3";
          src = fetchzip {
            url = "https://github.com/jepsen-io/maelstrom/releases/download/v0.2.3/maelstrom.tar.bz2";
            hash = "sha256-mE/FIHDLYd1lxAvECZGelZtbo0xkQgMroXro+xb9bMI=";
          };
          buildInputs = [ makeWrapper ];
          installPhase = ''
            mkdir -p $out/bin $out/lib
            cp lib/maelstrom.jar $out/lib/maelstrom.jar
            makeWrapper ${jre}/bin/java $out/bin/maelstrom --add-flags "-Djava.awt.headless=true -jar $out/lib/maelstrom.jar"
          '';
          propagatedBuildInputs = [ graphviz gnuplot ];
        };
      }
    );
}
