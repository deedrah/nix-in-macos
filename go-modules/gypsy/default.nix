{ fetchFromGitHub, go }:

go.buildGoPackage {
  name = "gypsy";

  goPackagePath = "github.com/kylelemons/go-gypsy";
  src = fetchFromGitHub {
    owner = "kylelemons";
    repo = "go-gypsy";
    rev = "08cad365cd28a7fba23bb1e57aa43c5e18ad8bb8";
    sha256 = "1djv7nii3hy451n5jlslk0dblqzb1hia1cbqpdwhnps1g8hqjy8q";
  };
}
