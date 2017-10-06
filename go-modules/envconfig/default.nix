{ fetchFromGitHub, go }:
go.buildGoPackage {
  name = "envconfig";

  goPackagePath = "github.com/kelseyhightower/envconfig";
  src = fetchFromGitHub {
    owner = "kelseyhightower";
    repo = "envconfig";
    rev = "462fda1f11d8cad3660e52737b8beefd27acfb3f";
    sha256 = "0zl6yy5injqqc8l2b761apb5mijn41sqw507pjzlclrykd3niksw";
  };
}
