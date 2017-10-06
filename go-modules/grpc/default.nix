{ go, fetchFromGitHub }:
go.buildGoPackage {
  name = "grpc";

  goPackagePath = "google.golang.org/grpc";
  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc-go";
    rev = "v1.4.1";
    sha256 = "0mgaacri5zmj1df1661166hmw3g40haskrsqpwjz4ivaf1svhykl";
  };

  buildInputs = with go; [ x.net x.text protobuf glog ];

  goDeps = with go; [ go.genproto cloud x.oauth2 ];

}
