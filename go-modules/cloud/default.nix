{ go, fetchgit }:
go.buildGoPackage rec {
  name = "cloud";

  goPackagePath = "google.golang.org/cloud";
  src = fetchgit {
    url = "https://code.googlesource.com/gocloud";
    rev = "6335269abf9002cf5a84613c13cda6010842b834";
    sha256 = "15xrqxna5ms0r634k3bfzyymn431dvqcjwbsap8ay60x371kzbwf";
  };

  buildInputs = with go; [ x.net x.text protobuf ];
  goDeps = with go; [ x.oauth2 grpc genproto ];

}
