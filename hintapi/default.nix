{ go, goutils
, iris, iris-weather, iris-music
}:
go.buildGoPackage rec {
  name = "hintapi";

  goPackagePath = "nohup.cz/hintapi";
  src = ./. ;

  buildInputs = with go; [
    x.net x.text x.sys x.crypto
    grpc genproto go.protobuf grpc-middleware
    cmux logrus dns envconfig
    aws-sdk httpstat mapstructure
  ];

  enableParallelBuilding = false;

  goDeps = [ goutils iris iris-weather iris-music ];

}
