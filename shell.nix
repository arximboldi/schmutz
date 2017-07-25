with import <nixpkgs> {};

{ compiler ? "gcc5" }:

let
  callable_traits = import ./nix/callable_traits.nix;
  docs = import ./nix/docs.nix;
  compiler_pkg = pkgs.${compiler};
  native_compiler = compiler_pkg.isClang == stdenv.cc.isClang;
in

stdenv.mkDerivation rec {
  name = "schmutz-env";
  buildInputs = [
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
  propagatedBuildInputs = stdenv.lib.optional (!native_compiler) compiler_pkg;
  nativeBuildInputs = stdenv.lib.optional native_compiler compiler_pkg;
}
