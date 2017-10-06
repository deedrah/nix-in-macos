{ fetchFromGitHub, go }:

go.buildGoPackage {
  name = "testdb";

  goPackagePath = "github.com/erikstmartin/go-testdb";
  src = fetchFromGitHub {
    owner = "erikstmartin";
    repo = "go-testdb";
    rev = "8d10e4a1bae52cd8b81ffdec3445890d6dccab3d";
    sha256 = "1fhrqcpv8x74qwxx9gpnhgqbz5wkp2bnsq92w418l1fnrgh4ppmq";
  };
}
