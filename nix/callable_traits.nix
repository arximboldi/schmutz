with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "callable_traits-${version}";
  version = "git-${commit}";
  commit = "684dfbd7dfbdd0438ef3670be10002ca33a71715";
  src = fetchFromGitHub {
    owner = "badair";
    repo = "callable_traits";
    rev = commit;
    sha256 = "1qnprz2lznm6b90xsj7jl2bk5cbvks4mzv5l8ks7cqpwyi128w0n";
  };
  nativeBuildInputs = [ cmake ];
  enableParallelBuilding = true;
  meta = with stdenv.lib; {
    homepage = "https://github.com/badair/callable_traits";
    description = "C++11 header-only library for the inspection, synthesis, and decomposition of callable types";
    license = licenses.boost;
  };
}
