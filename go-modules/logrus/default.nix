{ fetchFromGitHub, go }:
go.buildGoPackage {
  name = "logrus";

  goPackagePath = "github.com/sirupsen/logrus";
  src = fetchFromGitHub {
    owner = "sirupsen";
    repo = "logrus";
    rev = "89742aefa4b206dcf400792f3bd35b542998eb3b";
    sha256 = "0hk7fabx59msg2y0iik6xvfp80s73ybrwlcshbm9ds91iqbkcxi6";
  };

  buildInputs = with go; [ x.crypto x.sys ];
}
