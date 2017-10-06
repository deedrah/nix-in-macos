{ go, fetchFromGitHub }:
go.buildGoPackage {
  name = "protobuf";

  goPackagePath = "github.com/golang/protobuf";
  src = fetchFromGitHub {
    owner = "golang";
    repo = "protobuf";
    rev = "130e6b02ab059e7b717a096f397c5b60111cae74";
    sha256 = "0zk4d7gcykig9ld8f5h86fdxshm2gs93a2xkpf52jd5m4z59q26s";
  };
}
