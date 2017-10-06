{ fetchFromGitHub, go }:

go.buildGoPackage {
  name = "mapstructure";

  goPackagePath = "github.com/mitchellh/mapstructure";
  src = fetchFromGitHub {
    owner = "mitchellh";
    repo = "mapstructure";
    rev = "d0303fe809921458f417bcf828397a65db30a7e4";
    sha256 = "1fjwi5ghc1ibyx93apz31n4hj6gcq1hzismpdfbg2qxwshyg0ya8";
  };
}
