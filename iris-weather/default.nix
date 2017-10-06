{ go, goutils, iris
}:
go.buildGoPackage rec {
  name = "iris-weather";

  goPackagePath = "nohup.cz/iris-weather";
  src = ./. ;
  enableParallelBuilding = false;

  buildInputs = with go; [
    x.net x.text x.sys x.crypto
    grpc genproto go.protobuf grpc-middleware
    aws-sdk golang-geo mymysql pq testdb gypsy arg
    cmux logrus dns golang-set envconfig
  ];

  goDeps = [ goutils iris ];

}
