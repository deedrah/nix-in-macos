{ fetchFromGitHub, go }:
go.buildGoPackage {
  name = "cmux";

  goPackagePath = "github.com/soheilhy/cmux";
  src = fetchFromGitHub {
    owner = "soheilhy";
    repo = "cmux";
    rev = "bb79a83465015a27a175925ebd155e660f55e9f1";
    sha256 = "1mq1ycbizlm9bmv9vr1il4d32hlq9mh1aaag8kbph0dqis86m4cl";
  };

  buildInputs = with go; [ x.net x.text ];
}
