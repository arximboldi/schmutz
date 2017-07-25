with import <nixpkgs> {};

let
  callable_traits = import ./nix/callable_traits.nix;
  docs = import ./nix/docs.nix;
in

stdenv.mkDerivation rec {
  name = "schmutz-env";
  env = buildEnv { name = name; paths = buildInputs; };
  buildInputs = [
    cmake
    pkgconfig
    guile
    callable_traits
    cmake
    gcc6
    clang_38
    doxygen
    ninja
    docs.sphinx_arximboldi
    docs.breathe_arximboldi
    docs.recommonmark
  ];
}
