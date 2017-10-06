{ go, goutils, iris
}:
go.buildGoPackage rec {
  name = "iris-music";

  goPackagePath = "nohup.cz/iris-music";
  src = ./. ;
  compileProtos = true;
  enableParallelBuilding = false;

  buildInputs = with go; [
    x.net x.text x.sys x.crypto
    grpc genproto go.protobuf grpc-middleware
    aws-sdk cmux logrus dns envconfig
  ];

  goDeps = [ goutils iris ];

}
