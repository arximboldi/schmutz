with import <nixpkgs> {};

let
  callable_traits = import ./nix/callable_traits.nix;
in

stdenv.mkDerivation rec {
  name = "schmutz-git";
  version = "git";
  src = builtins.filterSource (path: type:
            baseNameOf path != ".git" &&
            baseNameOf path != "build" &&
            baseNameOf path != "_build" &&
            baseNameOf path != "tools")
          ./.;
  nativeBuildInputs = [
    cmake
    pkgconfig
  ];
  propagatedBuildInputs = [
    guile
    callable_traits
  ];
  enableParallelBuilding = true;
  meta = with stdenv.lib; {
    homepage    = "https://github.com/arximboldi/schmutz";
    description = "Easy bindings between C++ and Scheme";
    license     = licenses.boost;
  };
}
