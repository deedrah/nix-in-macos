{ fetchgit, go }:
go.buildGoPackage {
  name = "x.sys";

  goPackagePath = "golang.org/x/sys";
  src = fetchgit {
    url = "https://go.googlesource.com/sys";
    rev = "314a259e304ff91bd6985da2a7149bbf91237993";
    sha256 = "0vya62c3kmhmqx6awlxx8hc84987xkym9rhs0q28vlhwk9kczdaa";
  };
}
