{ fetchFromGitHub, go }:

go.buildGoPackage {
  name = "arg";

  goPackagePath = "github.com/alexflint/go-arg";
  src = fetchFromGitHub {
    owner = "alexflint";
    repo = "go-arg";
    rev = "398a01ebab8b6260be8714a39ad19ecb0db58dc1";
    sha256 = "1mcri0z6qravjn0xl5r6sinm8rw9z9rrz1d9i84misd0la7ff7x9";
  };
}
