{ fetchFromGitHub, go }:

go.buildGoPackage {
  name = "httpstat";

  goPackagePath = "github.com/tcnksm/go-httpstat";
  src = fetchFromGitHub {
    owner = "tcnksm";
    repo = "go-httpstat";
    rev = "6962beb23919c3de82c788a87b36f4f901ab514d";
    sha256 = "19006cfznr30dzp52a3kx975kqx1fln9cy7d0l1hczg9czb94c9q";
  };
}
