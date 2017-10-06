{ go, iris
}:
go.buildGoPackage rec {
  name = "goutils";

  goPackagePath = "nohup.cz/goutils";
  src = ./. ;

  buildInputs = with go; [
    x.text x.net x.crypto x.sys
    grpc genproto protobuf grpc-middleware
    cmux logrus dns aws-sdk
  ];

  enableParallelBuilding = false;

  goDeps = [ iris ];
}
