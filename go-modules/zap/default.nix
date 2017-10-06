{ fetchFromGitHub, go }:
go.buildGoPackage {
  name = "zap";

  goPackagePath = "go.uber.org/zap";
  src = fetchFromGitHub {
    owner = "uber-go";
    repo = "zap";
    rev = "35aad584952c3e7020db7b839f6b102de6271f89";
    sha256 = "0n79ir7jcr7s51j85swji7an0jgy1w5dxg1g68j722rmpbvsagwv";
  };

  #buildInputs = with go; [ x.net x.text x.crypto x.sys protobuf grpc genproto logrus ];
}
