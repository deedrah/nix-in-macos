{ go, goutils
}:
go.buildGoPackage rec {
  name = "iris";

  goPackagePath = "nohup.cz/iris";
  src = ./. ;
  compileProtos = true;

  buildInputs = with go; [
    x.net x.text x.sys x.crypto
    grpc genproto protobuf grpc-middleware
    aws-sdk cmux dns logrus golang-set envconfig
  ];

  enableParallelBuilding = false;

  goDeps = [ goutils ];

}
