{ fetchgit, go }:
go.buildGoPackage {
  name = "x.text";

  goPackagePath = "golang.org/x/text";
  src = fetchgit {
    url = "https://go.googlesource.com/text";
    rev = "1cbadb444a806fd9430d14ad08967ed91da4fa0a";
    sha256 = "0ih9ysagh4ylj08393497sscf3yziybc6acg4mrh0wa7mld75j56";
  };

  goDeps = with go; [ x.tools ];
}
