/*
 * nix specifications
 */

with import <nixpkgs> {};

let callable_traits_commit = "684dfbd7dfbdd0438ef3670be10002ca33a71715"; in

rec {

callable_traits = stdenv.mkDerivation rec {
  name = "callable_traits-${version}";
  version = callable_traits_commit;
  src = fetchFromGitHub {
    owner = "badair";
    repo = "callable_traits";
    rev = callable_traits_commit;
    sha256 = "1qnprz2lznm6b90xsj7jl2bk5cbvks4mzv5l8ks7cqpwyi128w0n";
  };
  nativeBuildInputs = [ cmake ];
  enableParallelBuilding = true;
  meta = with stdenv.lib; {
    homepage    = "https://github.com/badair/callable_traits";
    description = "C++11 header-only library for the inspection, synthesis, and decomposition of callable types";
    license     = licenses.boost;
  };
};

schmutz = stdenv.mkDerivation rec {
  name = "schmutz-git";
  version = "git";
  src = builtins.filterSource (path: type:
            baseNameOf path != ".git" &&
            baseNameOf path != "build")
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
};

schmutz_env = stdenv.mkDerivation rec {
  name = "schmutz-env";
  env = buildEnv { name = name; paths = buildInputs; };
  buildInputs = [
    schmutz
    cmake
    gcc6
    clang_38
    doxygen
    python27Packages.pip
  ];
};

}
