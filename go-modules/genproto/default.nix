{ go, fetchFromGitHub }:
go.buildGoPackage {
  name = "genproto";

  goPackagePath = "google.golang.org/genproto";
  src = fetchFromGitHub {
    owner = "google";
    repo = "go-genproto";
    rev = "1e559d0a00eef8a9a43151db4665280bd8dd5886";
    sha256 = "1dfm8zd9mif1aswks79wgyi7n818s5brbdnnrrlg79whfhaf20hd";
  };

  buildInputs = with go; [ x.net x.text protobuf ];
  goDeps = with go; [ grpc ];

}
