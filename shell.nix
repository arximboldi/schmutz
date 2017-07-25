with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "schmutz-dev-env";
  env = buildEnv { name = name; paths = buildInputs; };
  buildInputs = [
    gcc6
    clang_38
    guile
    pkgconfig
    cmake
    doxygen
    python27Packages.pip
  ];
}
