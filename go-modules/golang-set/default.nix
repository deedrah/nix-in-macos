{ fetchFromGitHub, go }:
go.buildGoPackage {
  name = "golang-set";

  goPackagePath = "github.com/deckarep/golang-set";
  src = fetchFromGitHub {
    owner = "deckarep";
    repo = "golang-set";
    rev = "b3af78e1d186c53529e3c916055d734665f68121";
    sha256 = "17yv9d4k66sivr1jasmg56qvfgkhzpfjarih3ywnmlrl2dcxgx9d";
  };
}
