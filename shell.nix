with import <nixpkgs> {};

let
  schmutz = import ./default.nix;
in

stdenv.mkDerivation rec {
  name = "schmutz-env";
  env = buildEnv { name = name; paths = buildInputs; };
  buildInputs = [
    schmutz
    cmake
    gcc6
    clang_38
    doxygen
    ninja
  ];
}
