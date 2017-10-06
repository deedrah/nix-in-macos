{ go, fetchgit }:
go.buildGoPackage rec {
  name = "x.oauth2";

  goPackagePath = "golang.org/x/oauth2";
  src = fetchgit {
    url = "https://go.googlesource.com/oauth2";
    rev = "397fe7649477ff2e8ced8fc0b2696f781e53745a";
    sha256 = "0fza0l7iwh6llkq2yzqn7dxi138vab0da64lnghfj1p71fprjzn8";
  };

  buildInputs = with go; [ x.net ];
  goDeps = with go; [ cloud ];

}
