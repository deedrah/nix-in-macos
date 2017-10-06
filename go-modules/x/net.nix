{ fetchgit, go }:
go.buildGoPackage {
  name = "x.net";

  goPackagePath = "golang.org/x/net";
  src = fetchgit {
    url = "https://go.googlesource.com/net";
    rev = "0a9397675ba34b2845f758fe3cd68828369c6517";
    sha256 = "19h1lqs8w2rh0263g9z6ff66rz736kkkfbx6l9wp9lpgy720fhcf";
  };

  goDeps = with go; [ x.text x.crypto ];
}
