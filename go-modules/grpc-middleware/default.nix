{ fetchFromGitHub, go }:
go.buildGoPackage {
  name = "grpc-middleware";

  goPackagePath = "github.com/mwitkow/go-grpc-middleware";
  goPackageAliases = [ "github.com/grpc-ecosystem/go-grpc-middleware" ];
  subPackages = [ "." ];
  src = fetchFromGitHub {
    owner = "grpc-ecosystem";
    repo = "go-grpc-middleware";
    rev = "6d3547c644afb325c16df96e3c7177ea6e2fdebd";
    sha256 = "1v0jshchz5ywj7dfyg0fwsfxvygyfmrrjc7cl24zzaidrw8lzwv0";
  };

  buildInputs = with go; [ x.net x.text x.crypto x.sys protobuf grpc genproto logrus ];

}
