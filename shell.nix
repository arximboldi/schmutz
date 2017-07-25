with import <nixpkgs> {};

{ compiler ? "gcc5" }:

let
  callable_traits = import ./nix/callable_traits.nix;
  docs = import ./nix/docs.nix;
  compiler_pkg = pkgs.${compiler};
in

stdenv.mkDerivation rec {
  name = "schmutz-env";
  propagatedBuildInputs = [
    compiler_pkg
    cmake
    pkgconfig
    guile
    callable_traits
    doxygen
    ninja
    docs.sphinx_arximboldi
    docs.breathe_arximboldi
    docs.recommonmark
  ];
}
